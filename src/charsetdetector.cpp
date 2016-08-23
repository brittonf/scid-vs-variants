//////////////////////////////////////////////////////////////////////
//
//  FILE:       charsetdetector.cpp
//              CharsetDetector class methods
//
//  Part of:    Scid vs. PC
//  Version:    4.15
//
//  Notice:     Copyright (c) 2015-2016  Gregor Cramer.  All rights reserved.
//
//  Author:     Gregor Cramer (gcramer@users.sourceforge.net)
//
//////////////////////////////////////////////////////////////////////

#include "charsetdetector.h"
#include "charsetconverter.h"
#include "textbuf.h"
#include "myassert.h"


static bool
isAscii(char const* str, unsigned len)
{
  for ( ; *str; ++str)
  {
    if (*str & 0x80)
      return false;
  }

  return true;
}


CharsetDetector::Info::Info()
  :m_encoding("ascii")
  ,m_charset(ASCII)
{
}


void
CharsetDetector::Info::setup(std::string const& encoding)
{
  m_encoding = encoding;
  
  switch (encoding[0])
  {
    case 'a': m_charset = (encoding == "ascii") ? ASCII : Other; break;
    case 'i': m_charset = (encoding == "iso8859-1") ? Latin1 : Other; break;
    case 'u': m_charset = (encoding == "utf-8") ? UTF8 : Other; break;
    case 'c': m_charset = (encoding == "cp1252") ? Windoze : (encoding == "cp850" ? DOS : Other); break;
    default: m_charset = Other; break;
  }
}


CharsetDetector::CharsetDetector()
  :m_ascii(0)
  ,m_latin1(0)
  ,m_cp850(0)
  ,m_cp1252(0)
  ,m_latin1Detected(false)
  ,m_cp1252Detected(false)
  ,m_cp850Detected(false)
{
}


void CharsetDetector::reset()
{
  Reset();
  m_ascii = 0;
  m_latin1 = 0;
  m_cp850 = 0;
  m_cp1252 = 0;
  m_info.setup("ascii");
}


void CharsetDetector::detect(char const* value, unsigned len)
{
  ASSERT(value);

  if (!::isAscii(value, len))
  {
    m_ascii = -1;
    HandleData(value, len);
  }

  if (m_latin1 >= 0)
  {
    int weight = CharsetConverter::detectLatin1(value, len);

    if (weight == -1)
      m_latin1 = -1;
    else
      m_latin1 += weight;
  }

  if (m_cp850 >= 0)
  {
    int weight = CharsetConverter::detectCP850(value, len);

    if (weight == -1)
      m_cp850 = -1;
    else
      m_cp850 += weight;
  }

  if (m_cp1252 >= 0)
  {
    int weight = CharsetConverter::detectCP1252(value, len);

    if (weight == -1)
      m_cp1252 = -1;
    else
      m_cp1252 += weight;
  }
}


void
CharsetDetector::finish2()
{
    if (m_cp1252 > m_cp850)
    {
      setup("cp1252");
      m_cp1252Detected = true;
    }
    else if (m_cp850 >= 0)
    {
      if (m_cp1252 >= 0 && m_cp1252Detected)
      {
        setup("cp1252");   // it's more likely Windoze
      }
      else if (m_latin1 >= 0 && m_latin1Detected)
      {
        setup("iso8859-1"); // it's more likely Latin-1
      }
      else
      {
        setup("cp850");
        m_cp850Detected = true;
      }
    }
}


void
CharsetDetector::finish()
{
  DataEnd();

  if ((isASCII() && m_ascii == -1) || (isLatin1() && m_latin1 == -1))
  {
    if (m_latin1 >= 0 && m_latin1 >= m_cp850 && m_latin1 >= m_cp1252)
    {
      setup("iso8859-1");
      m_latin1Detected = true;
    }
    else
    {
      finish2();
    }
  }
  else if (isLatin1())
  {
    if (m_latin1 >= m_cp850 && m_latin1 >= m_cp1252)
    {
      setup("iso8859-1");
      m_latin1Detected = true;
    }
    else
    {
      finish2();
    }
  }
}


void CharsetDetector::detect(TextBuffer const& text_)
{
  // NOTE: TextBuffer does not provide constness.
  TextBuffer& text = const_cast<TextBuffer&>(text_);
  HandleData(text.GetBuffer(), text.GetByteCount());
  DataEnd();
}


void CharsetDetector::Report(char const* charset)
{
  if (!m_latin1Detected && !m_cp1252Detected && !m_cp850Detected)
    m_info.setup(charset);
}

//////////////////////////////////////////////////////////////////////
//  EOF: charsetdetector.cpp
//////////////////////////////////////////////////////////////////////
// vi:set ts=2 sw=2 et:
