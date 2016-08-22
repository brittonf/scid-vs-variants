//////////////////////////////////////////////////////////////////////
//
//  FILE:       charsetconverter.cpp
//              CharsetConverter class methods
//
//  Part of:    Scid vs. PC
//  Version:    4.15
//
//  Notice:     Copyright (c) 2015-2016  Gregor Cramer.  All rights reserved.
//
//  Author:     Gregor Cramer (gcramer@users.sourceforge.net)
//
//////////////////////////////////////////////////////////////////////

#include "charsetconverter.h"
#include "textbuf.h"
#include "myassert.h"

#include <string.h>
#include <tcl.h>

#if __cplusplus < 201103 // no c++11 ?
# define nullptr NULL
#endif


namespace {

// adopted from Frank Yung-Fong Tang <http://people.netscape.com/ftang/utf8/isutf8.c>
//
// Valid octet sequences:
// 00-7f
//  c2-df  80-bf
//  e0     a0-bf 80-bf
//  e1-ec  80-bf 80-bf
//  ed     80-9f 80-bf
//  ee-ef  80-bf 80-bf
//  f0     90-bf 80-bf 80-bf
//  f1-f3  80-bf 80-bf 80-bf
//  f4     80-8f 80-bf 80-bf

enum State { Start, A, B, C, D, E, F, G, Error };

static unsigned char const Byte_Class_Lookup_Tbl[256] =
{
//00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 00
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 10
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 20
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 30
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 40
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 50
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 60
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 70
  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, // 80
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, // 90
  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, // A0
  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, // B0
  4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, // C0
  5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, // D0
  6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, // E0
  9,10,10,10,11, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, // F0
};

#define _ Error
static enum State const State_Transition_Tbl[12][8] =
{
//  Start  A      B      C      D      E      F      G
  { Start, _    , _    , _    , _    , _    , _    , _    }, //  0: 00-7f
  { _    , Start, A    , _    , A    , B    , _    , B    }, //  1: 80-8f
  { _    , Start, A    , _    , A    , B    , B    , _    }, //  2: 90-9f
  { _    , Start, A    , A    , _    , B    , B    , _    }, //  3: a0-bf
  { _    , _    , _    , _    , _    , _    , _    , _    }, //  4: c0-c1, f5-ff
  { A    , _    , _    , _    , _    , _    , _    , _    }, //  5: c2-df
  { C    , _    , _    , _    , _    , _    , _    , _    }, //  6: e0
  { B    , _    , _    , _    , _    , _    , _    , _    }, //  7: e1-ec, ee-ef
  { D    , _    , _    , _    , _    , _    , _    , _    }, //  8: ed
  { F    , _    , _    , _    , _    , _    , _    , _    }, //  9: f0
  { E    , _    , _    , _    , _    , _    , _    , _    }, // 10: f1-f3
  { G    , _    , _    , _    , _    , _    , _    , _    }, // 11: f4
};
#undef _


inline static State
nextState(State current, unsigned char c)
{
  return State_Transition_Tbl[Byte_Class_Lookup_Tbl[c]][current];
}

} // namespace


#define _ -1
static int8_t const CP850Weight[256] =
{
  0, 0, 0, 0, 0, 0, 0, 0, // 00 ... 07
  0, 0, 0, 0, 0, 0, 0, 0, // 08 ... 0f
  0, 0, 0, 0, 0, 0, 0, 0, // 10 ... 17
  0, 0, 0, 0, 0, 0, 0, 0, // 18 ... 1f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 ... 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 ... 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 ... 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 ... 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 40 ... 47
  0, 0, 0, 0, 0, 0, 0, 0, // 48 ... 4f
  0, 0, 0, 0, 0, 0, 0, 0, // 50 ... 57
  0, 0, 0, 0, 0, 0, 0, 0, // 58 ... 5f
  0, 0, 0, 0, 0, 0, 0, 0, // 60 ... 67
  0, 0, 0, 0, 0, 0, 0, 0, // 68 ... 6f
  0, 0, 0, 0, 0, 0, 0, 0, // 70 ... 77
  0, 0, 0, 0, 0, 0, 0, 0, // 78 ... 7f

  1, 5, 3, 1, 5, 1, 1, 1, // 80 ... 87
  1, 1, 2, 1, 1, 1, 5, 1, // 88 ... 8f
  1, 2, 2, 1, 5, 1, 1, 1, // 90 ... 97
  1, 5, 5, 1, 0, 0, 0, 0, // 98 ... 9f
  3, 1, 1, 1, 3, 3, 0, 0, // a0 ... a7
  3, 1, 1, 1, 1, 1, 1, 1, // a8 ... af
  _, _, _, _, _, 1, 1, 1, // b0 ... b7
  0, _, _, _, _, 0, 0, _, // b7 ... bf
  _, _, _, _, _, _, 1, 1, // c0 ... c7
  _, _, _, _, _, _, _, 0, // c8 ... cf
  0, 0, 1, 1, 1, 0, 0, 0, // d0 ... d7
  0, _, _, _, _, _, _, _, // d8 ... df
  0, 0, 0, 0, 0, 0, 0, 0, // e0 ... e7
  0, 0, 0, 0, 0, 0, 0, 0, // e8 ... ef
  0, 1, 1, 1, 0, 0, 0, 0, // f0 ... f7
  0, 0, 0, 0, 0, 0, 0, 0, // f8 ... ff
};

// NOTE: ChessBase is using code point 0x90,
// although this code point does not belong to cp1252.
// Later this character (U+2017) will be mapped correctly.
static int8_t const CP1252Weight[256] =
{
  0, 0, 0, 0, 0, 0, 0, 0, // 00 ... 07
  0, 0, 0, 0, 0, 0, 0, 0, // 08 ... 0f
  0, 0, 0, 0, 0, 0, 0, 0, // 10 ... 17
  0, 0, 0, 0, 0, 0, 0, 0, // 18 ... 1f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 ... 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 ... 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 ... 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 ... 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 40 ... 47
  0, 0, 0, 0, 0, 0, 0, 0, // 48 ... 4f
  0, 0, 0, 0, 0, 0, 0, 0, // 50 ... 57
  0, 0, 0, 0, 0, 0, 0, 0, // 58 ... 5f
  0, 0, 0, 0, 0, 0, 0, 0, // 60 ... 67
  0, 0, 0, 0, 0, 0, 0, 0, // 68 ... 6f
  0, 0, 0, 0, 0, 0, 0, 0, // 70 ... 77
  0, 0, 0, 0, 0, 0, 0, 0, // 78 ... 7f

  1, _, 0, 0, 0, 0, 0, 0, // 80 ... 87
  0, 0, 1, 0, 1, _, 0, _, // 88 ... 8f
  1, 0, 0, 0, 0, 0, 0, 0, // 90 ... 97
  0, 0, 1, 0, 1, _, 1, 0, // 98 ... 9f
  0, 1, 5, 5, 5, 5, 5, 5, // a0 ... a7
  0, 0, 0, 0, 0, 0, 0, 0, // a8 ... af
  0, 2, 0, 0, 0, 0, 0, 0, // b0 ... b7
  0, 0, 5, 1, 0, 1, 0, 2, // b8 ... bf
  1, 1, 1, 2, 5, 2, 2, 1, // c0 ... c7
  2, 3, 1, 1, 1, 1, 1, 1, // c8 ... cf
  0, 3, 2, 3, 1, 5, 5, 0, // d0 ... d7
  3, 1, 2, 1, 5, 1, 1, 5, // d8 ... df
  2, 3, 1, 1, 5, 3, 3, 1, // e0 ... e7
  2, 3, 1, 1, 1, 1, 1, 1, // e8 ... ef
  0, 2, 1, 3, 1, 1, 5, 0, // f0 ... f7
  3, 1, 3, 1, 5, 1, 0, 0, // f8 ... ff
};

static int8_t const Latin1Weight[256] =
{
  0, 0, 0, 0, 0, 0, 0, 0, // 00 ... 07
  0, 0, 0, 0, 0, 0, 0, 0, // 08 ... 0f
  0, 0, 0, 0, 0, 0, 0, 0, // 10 ... 17
  0, 0, 0, 0, 0, 0, 0, 0, // 18 ... 1f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 ... 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 ... 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 20 ... 27
  0, 0, 0, 0, 0, 0, 0, 0, // 28 ... 2f
  0, 0, 0, 0, 0, 0, 0, 0, // 40 ... 47
  0, 0, 0, 0, 0, 0, 0, 0, // 48 ... 4f
  0, 0, 0, 0, 0, 0, 0, 0, // 50 ... 57
  0, 0, 0, 0, 0, 0, 0, 0, // 58 ... 5f
  0, 0, 0, 0, 0, 0, 0, 0, // 60 ... 67
  0, 0, 0, 0, 0, 0, 0, 0, // 68 ... 6f
  0, 0, 0, 0, 0, 0, 0, 0, // 70 ... 77
  0, 0, 0, 0, 0, 0, 0, _, // 78 ... 7f

  _, _, _, _, _, _, _, _, // 80 ... 87
  _, _, _, _, _, _, _, _, // 88 ... 8f
  _, _, _, _, _, _, _, _, // 90 ... 97
  _, _, _, _, _, _, _, _, // 98 ... 9f
  0, 2, 0, 0, 0, 0, 0, 0, // a0 ... a7
  0, 1, 0, 1, 0, 0, 0, 0, // a8 ... af
  0, 2, 0, 0, 0, 0, 0, 0, // b0 ... b7
  0, 0, 5, 1, 0, 1, 0, 2, // b8 ... bf
  1, 1, 1, 2, 5, 2, 2, 1, // c0 ... c7
  2, 3, 1, 1, 1, 1, 1, 1, // c8 ... cf
  0, 3, 2, 3, 1, 5, 5, 0, // d0 ... d7
  3, 1, 2, 1, 5, 1, 1, 5, // d8 ... df
  2, 3, 1, 1, 5, 3, 3, 1, // e0 ... e7
  2, 3, 1, 1, 1, 1, 1, 1, // e8 ... ef
  0, 2, 1, 3, 1, 1, 5, 0, // f0 ... f7
  3, 1, 3, 1, 5, 1, 0, 0, // f8 ... ff
};
#undef _


inline static unsigned max(unsigned a, unsigned b) { return a < b ? b : a; }

inline static bool isFirst(char const* s) { return (static_cast<unsigned char>(*s) & 0xc0) != 0x80; }
inline static bool isTail(char const* s)  { return (static_cast<unsigned char>(*s) & 0xc0) == 0x80; }


namespace {
  namespace bits {

    static unsigned
    utf8CharLength(char const* str)
    {
      unsigned char c = *str;

      if ((c & 0xe0) == 0xc0) return 2;
      if ((c & 0xf0) == 0xe0) return 3;
      if ((c & 0xf8) == 0xf0) return 4;

      char const* t = str + 5;
      while (isTail(t))
        ++t;
      return t - str;
    }

  } // namespace bits
} // namespace


inline static unsigned
utf8CharLength(char const* str)
{
  return static_cast<unsigned char>(*str) < 0x80 ? 1 : bits::utf8CharLength(str);
}


static unsigned
utf8ToUnicode(char const* s, unsigned charLength)
{
  unsigned value = (static_cast<unsigned char>(*s) & (0xff >> (charLength + 1))) << ((charLength - 1)*6);

  for (charLength -= 1, s += 1; charLength > 0; --charLength, ++s)
    value |= (static_cast<unsigned char>(*s) - 0x80) << ((charLength - 1)*6);

  return value;
}


static char const*
findConversion(unsigned code)
{
  switch (code)
  {
    // Annotation symbols
    case 0x00ab: return "<<";   // Queenside
    case 0x00b1: return "+/-";  // White has a moderate advantage
    case 0x00bb: return ">>";   // Kingside
    case 0x01c1: return "&c";   // Etc
    case 0x2014: return "--";   // See
    case 0x203c: return "!!";   // Very good move
    case 0x2047: return "??";   // Very poor move
    case 0x2048: return "?!";   // Questionable move
    case 0x2049: return "!?";   // Interesting move
    case 0x20e4: return "/\\";  // With the idea
    case 0x2190: return "<-";   // Black has the attack
    case 0x2191: return "|^";   // White has the initiative
    case 0x2192: return "->";   // White has the attack
    case 0x2193: return "|v";   // Black has the initiative
    case 0x21b9: return "=&";   // Equal chances, active position
    case 0x21bb: return "@";    // Development
    case 0x21c6: return "<=>";  // Counterplay
    case 0x21d1: return "||^";  // White has a lasting initiative
    case 0x21d4: return "<->";  // Line
    case 0x21d7: return "/^";   // Diagonal
    case 0x2206: return "/\\";  // With the idea
    case 0x2213: return "-/+";  // Black has a moderate advantage
    case 0x221e: return "~~";   // Unclear position
    case 0x2228: return "\\/";  // Aimed against
    case 0x223c: return "~";    // With compensation
    case 0x2264: return "<=";   // Worse is
    case 0x226a: return "<<";   // Queenside
    case 0x226b: return ">>";   // Kingside
    case 0x227b: return ">";    // More pawns
    case 0x2295: return "(+)";  // Zeitnot
    case 0x2299: return "(.)";  // Zugzwang
    case 0x229e: return "[+]";  // Center
    case 0x22a5: return "_|_";  // Endgame
    case 0x22b6: return "^=";   // Bishops of same color
    case 0x22c1: return "\\/";  // Aimed against
    case 0x22d8: return "<<<";  // Black has a moderate kingside advantage
    case 0x22d9: return ">>>";  // White has a moderate kingside advantage
    case 0x230a: return "|_";   // With
    case 0x230b: return "_|";   // Without
    case 0x2313: return ">=";   // Better move
    case 0x259e: return "^=";   // Bishops of same color
    case 0x25a0: return "[]";   // Forced move
    case 0x25a1: return "[]";   // Singular move
    case 0x25b3: return "/\\";  // With the idea
    case 0x25dd: return "()";   // Space
    case 0x25e8: return "^_";   // Bishops of opposite color
    case 0x25eb: return "^^";   // Pair of bishops
    case 0x25ef: return "()";   // Space
    case 0x26a8: return "o^";   // Passed pawn
    case 0x26ae: return "o.o";  // Connected pawns
    case 0x26af: return "o/o";  // Isolated pawns
    case 0x2715: return "><";   // Weak point
    case 0x27e9: return ">";    // More pawns
    case 0x27ea: return "<<";   // Queenside
    case 0x27eb: return ">>";   // Kingside
    case 0x27fa: return "<->";  // Line
    case 0x2a71: return "=/+";  // Black has a slight advantage
    case 0x2a72: return "+/=";  // White has a slight advantage
    case 0x2b12: return "#";    // Diagram
    case 0x2b13: return "#";    // Diagram from black's perspective
    case 0x3007: return "()";   // Space
    case 0x300a: return "<<";   // Queenside
    case 0x300b: return ">>";   // Kingside

    // Some commonly used code points
    case 0x2002: return " ";    // EN SPACE
    case 0x2003: return " ";    // EM SPACE
    case 0x2004: return " ";    // THREE-PER-EM SPACE
    case 0x2005: return " ";    // FOUR-PER-EM SPACE
    case 0x2006: return " ";    // SIX-PER-EM SPACE
    case 0x2007: return " ";    // FIGURE SPACE
    case 0x2008: return " ";    // PUNCTUATION SPACE
    case 0x2009: return " ";    // THIN SPACE
    case 0x2010: return "-";    // HYPHEN
    case 0x2011: return "-";    // NON-BREAKING HYPHEN
    case 0x2012: return "--";   // FIGURE DASH
    case 0x2013: return "-";    // EN DASH
    case 0x2015: return "-";    // HORIZONTAL BAR
    case 0x2018: return "'";    // LEFT SINGLE QUOTATION MARK
    case 0x2019: return "'";    // RIGHT SINGLE QUOTATION MARK
    case 0x201a: return "'";    // SINGLE LOW-9 QUOTATION MARK
    case 0x201b: return "'";    // SINGLE HIGH-REVERSED-9 QUOTATION MARK
    case 0x201c: return "\"";   // LEFT DOUBLE QUOTATION MARK
    case 0x201d: return "\"";   // RIGHT DOUBLE QUOTATION MARK
    case 0x201e: return "\"";   // DOUBLE LOW-9 QUOTATION MARK
    case 0x201f: return "\"";   // DOUBLE HIGH-REVERSED-9 QUOTATION MARK
    case 0x2022: return "-";    // BULLET
    case 0x2026: return "...";  // HORIZONTAL ELLIPSIs
    case 0x20ac: return "Euro"; // EURO SIGN
    case 0x2122: return "TM";   // TRADE MARK SIGN
    case 0x2139: return "(i)";  // INFORMATION SOURCE
    case 0x2212: return "-";    // MINUS SIGN
    case 0x25cf: return "(*)";  // BLACK CIRCLE
    case 0x2605: return "*";    // BLACK STAR
    case 0x2654: return "K";    // WHITE CHESS KING
    case 0x2655: return "Q";    // WHITE CHESS QUEEN
    case 0x2656: return "R";    // WHITE CHESS ROOK
    case 0x2657: return "B";    // WHITE CHESS BISHOP
    case 0x2658: return "N";    // WHITE CHESS KNIGHT
    case 0x2659: return "P";    // WHITE CHESS PAWN
    case 0x265a: return "k";    // BLACK CHESS KING
    case 0x265b: return "q";    // BLACK CHESS QUEEN
    case 0x265c: return "r";    // BLACK CHESS ROOK
    case 0x265d: return "b";    // BLACK CHESS BISHOP
    case 0x265e: return "n";    // BLACK CHESS KNIGHT
    case 0x265f: return "p";    // BLACK CHESS PAWN
    case 0x270e: return "**";   // LOWER RIGHT PENCIl
    case 0xfffd: return "?";    // REPLACEMENT CHARACTER

    // some additional characters in CP850 / CP1252
    case 0x0152: return "OE";   // LATIN CAPITAL LIGATURE OE
    case 0x0153: return "oe";   // LATIN SMALL LIGATURE OE
    case 0x0160: return "S";    // LATIN CAPITAL LETTER S WITH CARON
    case 0x0161: return "s";    // LATIN SMALL LETTER S WITH CARON
    case 0x0178: return "Y";    // LATIN CAPITAL LETTER Y WITH DIAERESIS
    case 0x017d: return "Z";    // LATIN CAPITAL LETTER Z WITH CARON
    case 0x017e: return "z";    // LATIN SMALL LETTER Z WITH CARON
    case 0x0192: return "f";    // LATIN SMALL LETTER F WITH HOOK
    case 0x02dc: return "~";    // SMALL TILDE
    case 0x2017: return "_";    // DOUBLE LOW LINE
    case 0x2020: return "+";    // DAGGER
    case 0x2021: return "++";   // DOUBLE DAGGER
    case 0x2039: return "<";    // SINGLE LEFT-POINTING ANGLE QUOTATION MARK
    case 0x203a: return ">";    // SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
    case 0x02c6: return "^";    // MODIFIER LETTER CIRCUMFLEX ACCENT
    case 0x2030: return "o/oo"; // PER MILLE SIGN
    case 0x2261: return "=";    // IDENTICAL TO

    // ChessBase
    case 0x00a2: return "K";
    case 0x00a3: return "Q";
    case 0x00a4: return "N";
    case 0x00a5: return "B";
    case 0x00a6: return "R";
    case 0x00a7: return "P";
  }

  return nullptr;
}


inline static void
appendTwoOctets(std::string& result, unsigned code)
{
  char buf[2] = { char((code >> 6) | 0xc0), char((code & 0x3f) | 0x80) };
  result.append(buf, 2);
}


inline static void
appendThreeOctets(std::string& result, unsigned code)
{
  char buf[3] =
  {
    char((code >> 12) | 0xe0),
    char(((code >> 6) & 0x3f) | 0x80),
    char((code & 0x3f) | 0x80),
  };
  result.append(buf, 3);
}


inline static void
appendFourOctets(std::string& result, unsigned code)
{
  char buf[4] =
  {
    char((code >> 18) + 0xf0),
    char(((code >> 12) & 0x3f) | 0x80),
    char(((code >> 6) & 0x3f) | 0x80),
    char((code & 0x3f) | 0x80),
  };
  result.append(buf, 4);
}


static void
appendCodePointToUTF8String(std::string& result, unsigned code)
{
    if (code < 0x00000800)
      appendTwoOctets(result, code);
    else if (code < 0x0010000)
      appendThreeOctets(result, code);
    else
      appendFourOctets(result, code);
}


inline CharsetDetector::CharSet CharsetConverter::Codec::charset() const { return m_info.m_charset; }

inline bool CharsetConverter::Codec::isUTF8() const     { return m_info.isUTF8(); }
inline bool CharsetConverter::Codec::isLatin1() const   { return m_info.isLatin1(); }
inline bool CharsetConverter::Codec::isWindoze() const  { return m_info.isWindows(); }
inline bool CharsetConverter::Codec::isDOS() const      { return m_info.isDOS(); }


struct CharsetConverter::Buffer
{
  TextBuffer*   m_txt;
  std::string*  m_std;
  char const*   m_str;
  unsigned      m_size;

  Buffer(TextBuffer& buf) 
    :m_txt(&buf), m_std(nullptr), m_str(buf.GetBuffer()), m_size(buf.GetByteCount()) {}

  Buffer(std::string& buf)
    :m_txt(nullptr), m_std(&buf), m_str(buf.c_str()), m_size(buf.size()) {}

  char const* str() const { return m_str; }
  unsigned size() const   { return m_size; }

  void replace(std::string& str)
  {
    m_size = str.size();
    if (m_std)
      m_std->swap(str);
    else
      m_txt->ReplaceContent(str.c_str(), m_size);
  }
};


CharsetConverter::Codec::Codec()
  :m_impl(nullptr)
{
  ::memset(m_cache, 0, sizeof(m_cache));
  detectSystemEncoding();
}


CharsetConverter::Codec::Codec(std::string const& encoding)
  :m_impl(nullptr)
{
  ::memset(m_cache, 0, sizeof(m_cache));
  setup(encoding);
}


CharsetConverter::Codec::~Codec()
{
  for (unsigned i = 0; i < sizeof(m_cache)/sizeof(m_cache[0]); ++i)
  {
    if (m_cache[i])
      Tcl_FreeEncoding(m_cache[i]);
  }

  for (ImplMap::iterator i = m_implMap.begin(); i != m_implMap.end(); ++i)
    Tcl_FreeEncoding(i->second);
}


void
CharsetConverter::Codec::detectSystemEncoding()
{
  Tcl_DString buf;
  Tcl_DStringInit(&buf);
  setup(Tcl_GetEncodingNameFromEnvironment(&buf));
  Tcl_DStringFree(&buf);
}


void
CharsetConverter::Codec::setupImpl()
{
  if (m_info.m_charset == CharsetDetector::Other)
  {
    std::pair<ImplMap::iterator,bool> result =
        m_implMap.insert(ImplMap::value_type(m_info.m_encoding, nullptr));

    if (result.second)
      result.first->second = m_impl = Tcl_GetEncoding(nullptr, m_info.m_encoding.c_str());
    else
      m_impl = result.first->second;
  }
  else
  {
    if (!m_cache[m_info.m_charset])
      m_cache[m_info.m_charset] = Tcl_GetEncoding(nullptr, m_info.m_encoding.c_str());

    m_impl = m_cache[m_info.m_charset];
  }
}


void
CharsetConverter::Codec::setup(std::string const& encoding)
{
  m_info.setup(encoding);
  setupImpl();
}


void
CharsetConverter::Codec::setup(Info const& info)
{
  m_info = info;
  setupImpl();
}


CharsetConverter::CharsetConverter()
  :m_error(false)
  ,m_failed(false)
  ,m_unknown(0)
{
}


CharsetConverter::CharsetConverter(std::string const& encoding)
  :m_wanted(encoding)
  ,m_error(false)
  ,m_failed(false)
  ,m_unknown(0)
{
}


void
CharsetConverter::setupEncoding(std::string const& encoding)
{
  m_wanted.setup(encoding);
}


void
CharsetConverter::setupDetected()
{
  m_text.setup(m_detector.encoding());
}


bool
CharsetConverter::isAscii(char const* str)
{
  for ( ; *str; ++str)
  {
    if (*str & 0x80)
      return false;
  }

  return true;
}


bool
CharsetConverter::isConvertibleToLatin1(char const* str)
{
  while (*str)
  {
    unsigned char c = *str;

    if (c & 0x80)
    {
      unsigned charLen  = ::utf8CharLength(str);
      unsigned code     = ::utf8ToUnicode(str, charLen);

      if (::findConversion(code))
        str += charLen;
      else if (0x7f <= code && code <= 0x9f)
        return false;

      ASSERT(charLen == 2);
      str += 2;
    }
    else
    {
      str += 1;
    }
  }

  return true;
}


std::string
CharsetConverter::mapChessBaseFigurineToUTF8(const char* s)
{
  std::string str;

  while (*s)
  {
    unsigned char c = *s;

    if (c & 0x80)
    {
      unsigned charLen = ::utf8CharLength(s);
      unsigned char d = s[1];

      if (charLen == 2 && (0xc2 <= c && c <= 0xc3) && (0xa2 <= d && d <= 0xa7))
      {
        switch (d)
        {
          case 0xa2: ::appendThreeOctets(str, 0x2654); break; // King
          case 0xa3: ::appendThreeOctets(str, 0x2655); break; // Queen
          case 0xa4: ::appendThreeOctets(str, 0x2658); break; // Knight
          case 0xa5: ::appendThreeOctets(str, 0x2657); break; // Bishop
          case 0xa6: ::appendThreeOctets(str, 0x2656); break; // Rook
          case 0xa7: ::appendThreeOctets(str, 0x2659); break; // Pawn
        }
      }
      else
      {
        str.append(s, charLen);
      }

      s += charLen;
    }
    else
    {
      str += c;
      s += 1;
    }
  }

  return str;
}


bool
CharsetConverter::validateUTF8(char const* str, unsigned len)
{
  ASSERT(str);

  ::State state = ::Start;

  for (char const* e = str + len; str < e; ++str)
  {
    state = ::nextState(state, *str);

    if (state == ::Error)
      return false;
  }

  return state == ::Start;
}


bool
CharsetConverter::validateLatin1(char const* str, unsigned len)
{
  ASSERT(str);

  // NOTE: it is common that Latin-1 contains 0x00-0x1f, although this is not standard.

  for (char const* e = str + len; str < e; ++str)
  {
    unsigned char c = *str;

    if (0x7f <= c && c <= 0x9f)
      return false;
  }

  return true;
}


unsigned
CharsetConverter::makeValid(std::string& str, char const* replacement)
{
  unsigned removed = removeInvalidSequences(str, replacement);

  std::string result;

  char const* s = str.c_str();
  char const* e = s + str.size();
  char const* r = s;

  State state = Start;

  for ( ; s < e; ++s)
  {
    state = ::nextState(state, *s);

    switch (int(state))
    {
      case Error:
        result.append(replacement);
        state = Start;
        while (s < e && (::isTail(s) || ::nextState(state, *s) != Start))
          ++s;
        removed += 1;
        r = s;
        if (s < e)
          --s;
        break;

      case Start:
        result.append(r, (s + 1) - r);
        r = s + 1;
        break;
    }
  }

  if (state != Error && state != Start)
  {
    result.append(replacement);
    removed += 1;
  }

  str.swap(result);
  return removed;
}


int
CharsetConverter::detect(char const* s, unsigned len, int8_t const* table)
{
  int sum = 0;

  for (char const* e = s + len; s < e; ++s)
  {
    unsigned char c = *s;

    int8_t weight = table[c];

    if (weight < 0)
      return -1;

    sum += weight;
  }

  return sum;
}


int
CharsetConverter::detectCP850(char const* str, unsigned len)
{
  return detect(str, len, ::CP850Weight);
}


int
CharsetConverter::detectCP1252(char const* str, unsigned len)
{
  return detect(str, len, ::CP1252Weight);
}


int
CharsetConverter::detectLatin1(char const* str, unsigned len)
{
  return detect(str, len, ::Latin1Weight);
}


void
CharsetConverter::cp850ToUTF8(std::string const& in, std::string& out)
{
  for (char const* str = in.c_str(); *str; ++str)
  {
    unsigned char c = *str;

    if (c & 0x80)
    {
      static unsigned const CodeTable[128] =
      {
        0x00c7, 0x00fc, 0x00e9, 0x00e2, 0x00e4, 0x00e0, 0x00e5, 0x00e7, // 80 ... 87
        0x00ea, 0x00eb, 0x00e8, 0x00ef, 0x00ee, 0x00ec, 0x00c4, 0x00c5, // 88 ... 8f
        0x00c9, 0x00e6, 0x00c6, 0x00f4, 0x00f6, 0x00f2, 0x00fb, 0x00f9, // 90 ... 97
        0x00ff, 0x00d6, 0x00dc, 0x00f8, 0x00a3, 0x00d8, 0x00d7, 0x0192, // 98 ... 9f
        0x00e1, 0x00ed, 0x00f3, 0x00fa, 0x00f1, 0x00d1, 0x00aa, 0x00ba, // a0 ... a7
        0x00bf, 0x00ae, 0x00ac, 0x00bd, 0x00bc, 0x00a1, 0x00ab, 0x00bb, // a8 ... af
        0x2591, 0x2592, 0x2593, 0x2502, 0x2524, 0x00c1, 0x00c2, 0x00c0, // b0 ... b7
        0x00a9, 0x2563, 0x2551, 0x2557, 0x255d, 0x00a2, 0x00a5, 0x2510, // b8 ... bf
        0x2514, 0x2534, 0x252c, 0x251c, 0x2500, 0x253c, 0x00e3, 0x00c3, // c0 ... c7
        0x255a, 0x2554, 0x2569, 0x2566, 0x2560, 0x2550, 0x256c, 0x00a4, // c8 ... cf
        0x00f0, 0x00d0, 0x00ca, 0x00cb, 0x00c8, 0x0131, 0x00cd, 0x00ce, // d0 ... d7
        0x00cf, 0x2518, 0x250c, 0x2588, 0x2584, 0x00a6, 0x00cc, 0x2580, // d8 ... df
        0x00d3, 0x00df, 0x00d4, 0x00d2, 0x00f5, 0x00d5, 0x00b5, 0x00fe, // e0 ... e7
        0x00de, 0x00da, 0x00db, 0x00d9, 0x00fd, 0x00dd, 0x00af, 0x00b4, // e8 ... ef
        0x2261, 0x00b1, 0x2017, 0x00be, 0x00b6, 0x00a7, 0x00f7, 0x00b8, // f0 ... f7
        0x00b0, 0x00a8, 0x00b7, 0x00b9, 0x00b3, 0x00b2, 0x25a0, 0x00a0, // f8 ... ff
      };

      ::appendCodePointToUTF8String(out, CodeTable[c - 0x80]);
    }
    else
    {
      out += c;
    }
  }
}


void
CharsetConverter::cp1252ToUTF8(std::string const& in, std::string& out)
{
  for (char const* str = in.c_str(); *str; ++str)
  {
    unsigned char c = *str;

    if (c & 0x80)
    {
      if (c < 0xa8)
      {
        // NOTE: this table maps the special ChessBase code 0x90 to 0x21bb.
        static unsigned const CodeTable[128] =
        {
          0x20ac, 0xfffd, 0x201a, 0x0192, 0x201e, 0x2026, 0x2020, 0x2021, // 80 ... 87
          0x02c6, 0x2030, 0x0160, 0x2039, 0x0152, 0xfffd, 0x017d, 0xfffd, // 88 ... 8f
          0x21bb, 0x2018, 0x2019, 0x201c, 0x201d, 0x2022, 0x2013, 0x2014, // 90 ... 97
          0x02dc, 0x2122, 0x0161, 0x203a, 0x0153, 0xfffd, 0x017e, 0x0178, // 98 ... 9f
          0x02a0, 0x00a1, 0x2654, 0x2655, 0x2658, 0x2657, 0x2656, 0x2659, // a0 ... a7
        };

        ::appendCodePointToUTF8String(out, CodeTable[c - 0x80]);
      }
      else // this is identical to Latin-1
      {
        ::appendTwoOctets(out, c);
      }
    }
    else
    {
      out += c;
    }
  }
}


bool
CharsetConverter::fixLatin1(std::string const& in, std::string& out)
{
  char const* str = in.c_str();

  while (*str)
  {
    unsigned char c = *str;

    if (c & 0x80)
    {
      if (0xc2 <= c && c <= 0xc3)
      {
        c = str[1];

        if (c < 0x80 || 0xbf < c)
        {
          c = str[2];

          if (0x80 <= c && c <= 0xbf)
          {
            out += str[0];
            out += str[2];
            str += 3;
            continue;
          }
        }
      }

      unsigned len = ::utf8CharLength(str);
      out.append(str, len);
      str += len;
    }
    else
    {
      out += c;
      str += 1;
    }
  }

  return validateUTF8(out.c_str(), out.size());
}


unsigned
CharsetConverter::removeInvalidSequences(std::string& str, unsigned len, char const* replacement)
{
  ASSERT(len <= str.size());

  // remove overlong sequences:
  //    c0 xx
  //    e0 80 xx
  //    f0 80 80 xx
  //    f8 80 80 80 xx
  //    fc 80 80 80 80 xx

  std::string result;

  char const* s = str.c_str();
  char const* e = s + len;

  unsigned replaced = 0;

  while (s < e)
  {
    switch (::utf8CharLength(s))
    {
      case 1: // 0bbbbbbb
        result.append(s++, 1);
        break;

      case 2: // // 110bbbbb 10bbbbbb
        if ((s[1] & 0xc0) != 0x80)      // invalid
        {
          result.append(replacement);
          replaced += 1;
        }
        else if ((s[0] & 0xfe) == 0xc0)  // overlong
        {
          char buf[1] = { char(s[1] & 0x7f) };
          result.append(buf, 1);
        }
        else
        {
          result.append(s, 2);
        }

        s += 2;
        break;

      case 3: // 1110bbbb 10bbbbbb 10bbbbbb
        if ((s[1] & 0xc0) != 0x80 || (s[2] & 0xc0) != 0x80)    // invalid
        {
          result.append(replacement);
          replaced += 1;
        }
        else if (s[0] == 0xe0 && (s[1] & 0xe0) == 0x80)        // overlong
        {
          char buf[1] = { char(s[2] & 0x7f) };
          result.append(buf, 1);
        }
        else if (s[0] == 0xed && (s[1] & 0xe0) == 0xa0)        // surrogate
        {
          result.append(replacement);
          replaced += 1;
        }
        else if (s[0] == 0xef && s[1] == 0xbf && (s[2] & 0xfe) == 0xbe)  // U+FFFE or U+FFFF
        {
          result.append(replacement);
          replaced += 1;
        }
        else
        {
          result.append(s, 3);
        }

        s += 3;
        break;

      case 4: // 11110bbb 10bbbbbb 10bbbbbb 10bbbbbb
        if ((s[1] & 0xc0) != 0x80 || (s[2] & 0xc0) != 0x80 || (s[3] & 0xc0) != 0x80)  // invalid
        {
          result.append(replacement);
          replaced += 1;
        }
        else if (s[0] == 0xf0 && (s[1] & 0xf0) == 0x80)  // overlong
        {
          char buf[1] = { char(s[3] & 0x7f) };
          result.append(buf, 1);
        }
        else if ((s[0] == 0xf4 && s[1] > 0x8f) || s[0] > 0xf4)  // > U+10FFFF
        {
          result.append(replacement);
          replaced += 1;
        }
        else
        {
          result.append(s, 4);
        }

        s += 4;
        break;

      default:
        // this should not happen
        s += 5;
        while (s < e && ::isTail(s))
          ++s;
        result.append(replacement);
        replaced += 1;
        break;
    }
  }

  str.swap(result);
  return replaced;
}


bool
CharsetConverter::convertFromUTF8(std::string const& in, std::string& out)
{
  Tcl_EncodingState state;

  std::string buf(::max(in.size(), 255), ' ');

  char const*  src = in.c_str();
  char*        dst = const_cast<char*>(buf.data()); // it's only a buffer

  int flags   = TCL_ENCODING_START | TCL_ENCODING_END | TCL_ENCODING_STOPONERROR;
  int srcLen  = in.size();

  while (true)
  {
    int bytesIn, bytesOut, dstChars;

    int rc = Tcl_UtfToExternal( 0,
                                m_wanted.m_impl,
                                src, srcLen,
                                flags,
                                &state,
                                dst, buf.size(),
                                &bytesIn,
                                &bytesOut,
                                &dstChars);

    out.append(buf.c_str(), dst + bytesOut - buf.c_str());

    if (rc == TCL_OK)
      return true;

    src += bytesIn;
    srcLen -= bytesIn;

    switch (rc)
    {
      case TCL_CONVERT_NOSPACE:
        flags &= ~TCL_ENCODING_START;
        break;

      case TCL_CONVERT_UNKNOWN:
      {
        flags |= TCL_ENCODING_START;

        if (static_cast<unsigned char>(*src) & 0x80)
        {
          unsigned charLen  = ::utf8CharLength(src);
          unsigned code     = ::utf8ToUnicode(src, charLen);

          if (char const* conversion = ::findConversion(code))
          {
            out.append(conversion);
          }
          else
          {
            out.append("?", 1);
            m_unknown += 1;
          }

          src += charLen;
          srcLen -= charLen;
        }
        else // should never happen
        {
          out.append(src, 1); // this is ASCII
        }

        break;
      }

      case TCL_CONVERT_SYNTAX:
        m_error = true;
        out.append("?", 1);
        flags |= TCL_ENCODING_START;
        src += 1;
        srcLen -= 1;
        for (char const* e = src + srcLen; src < e && !::isFirst(src); ++src)
          srcLen -= 1;
        break;

      case TCL_CONVERT_MULTIBYTE:
        out.append("?", 1);
        m_error = true;
        return false;
    }
  }

  return false;  // not reached
}


bool
CharsetConverter::convertToUTF8(std::string const& in, std::string& out, char const* replacement)
{
  if (m_text.isWindoze())
  {
    cp1252ToUTF8(in, out);
    return true;
  }

  if (m_text.isDOS())
  {
    cp850ToUTF8(in, out);
    return true;
  }

  Tcl_EncodingState state;

  std::string buf(in.size()*4, ' ');

  char const*  src = in.c_str();
  char*        dst = const_cast<char*>(buf.data()); // it's only a buffer

  int flags   = TCL_ENCODING_START | TCL_ENCODING_END | TCL_ENCODING_STOPONERROR;
  int srcLen  = in.size();

  while (true)
  {
    int bytesIn, bytesOut, dstChars;

    int rc = Tcl_ExternalToUtf( 0,
                                m_text.m_impl,
                                src, srcLen,
                                flags,
                                &state,
                                dst, buf.size(),
                                &bytesIn,
                                &bytesOut,
                                &dstChars);

    int soFar = (dst + bytesOut) - buf.c_str();

    if (rc == TCL_OK)
    {
      buf.resize(soFar);

      if (!validateUTF8(buf))
      {
        // NOTE: sometimes Tcl_ExternalToUtf() is producing overlong UTF-8
        // sequences, this is a violation of the UTF-8 standard. We have
        // to fix this, hopefully without any loss.

        if (removeInvalidSequences(buf, replacement) > 0)
          m_failed = true;

        if (validateUTF8(buf))
        {
          out.append(buf);
        }
        else
        {
          out = in;

          if (!validateUTF8(out))
          {
            makeValid(out, replacement);
            m_failed = true;
          }
        }

        return false;
      }

      out.append(buf);
      return true;
    }

    out.append(buf.c_str(), soFar);

    src += bytesIn;
    srcLen -= bytesIn;

    switch (rc)
    {
      case TCL_CONVERT_NOSPACE:
        flags &= ~TCL_ENCODING_START;
        break;

      case TCL_CONVERT_UNKNOWN:
      case TCL_CONVERT_SYNTAX:
        if (bytesOut > 0 || src == in.c_str())
        {
          out.append(replacement);
          if (rc == TCL_CONVERT_UNKNOWN)
            m_unknown += 1;
          else
            m_error = true;
        }
        src += 1;
        srcLen -= 1;
        flags |= TCL_ENCODING_START;
        break;

      case TCL_CONVERT_MULTIBYTE:
        out.append(replacement);
        m_error = true;
        return false;
    }
  }

  return false;  // not reached
}


bool
CharsetConverter::doConversion(Buffer& text)
{
  if (isAscii(text.str()))
    return true;

  bool isUTF8 = validateUTF8(text.str(), text.size());

  if (isUTF8 && m_wanted.isUTF8())
    return true;

  m_detector.reset();
  m_detector.detect(text.str(), text.size());

  if (   m_detector.isASCII() // the detector couldn't detect the character set
      || (m_detector.isLatin1() && !validateLatin1(text.str(), text.size()))) // detection is wrong
  {
    // This may happen if:
    // 1. The character set is CP850 or CP1252 encoded with single bytes.
    // 2. The character set detection failed, sometimes this happens with Latin-1.

    int cp850  = detectCP850(text.str(), text.size());
    int cp1252 = detectCP1252(text.str(), text.size());
    int latin1 = detectLatin1(text.str(), text.size());

    if (latin1 >= 0 && latin1 >= cp1252 && latin1 >= cp850) // detection of Latin-1 failed
    {
      m_detector.setup("iso8859-1"); // but this seems to be Latin-1
    }
    else if (cp1252 > cp850) // most probably it's CP1252 (Windoze)
    {
      std::string src(text.str(), text.size());
      std::string dst;
      cp1252ToUTF8(src, dst);
      text.replace(dst);
      m_detector.setup("utf-8");
    }
    else if (cp850 >= 0) // probably it's CP850 (MSDOS)
    {
      std::string src(text.str(), text.size());
      std::string dst;
      cp850ToUTF8(src, dst);
      text.replace(dst);
      m_detector.setup("utf-8");
    }
    else if (m_detector.isLatin1()) // does not happen under Windoze
    {
      // ----------------------------------------------------------------------
      // This part is a bit experimental, and should be removed if
      // not successful in practice.
      // ----------------------------------------------------------------------
      std::string src(text.str(), text.size());
      std::string dst;

      if (fixLatin1(src, dst))
      {
        // This was originally a Latin-1 string with invalid UTF-8 conversion,
        // but we could restore the content. This happens often with Scid
        // databases. (For example an import of a PGN file with UTF-8 encoded
        // Latin-1 character set.)
        text.replace(dst);
        m_detector.setup("utf-8");
      }
    }
    else
    {
      // The character set is unrecognizable, so convertToUTF8() will do
      // the required conversions.
    }
  }

  if (m_detector.charset() == m_wanted.charset())
  {
    if (!m_wanted.isUTF8() || isUTF8)
      return true;

    std::string src(text.str(), text.size());
    return makeValid(src, m_wanted.isUTF8() ? "\xef\xbf\xbd" : "?") == 0;
  }

  if (m_detector.charset() != m_text.charset())
    m_text.setup(m_detector.m_info);

  std::string src(text.str(), text.size());
  std::string dst;

  bool rc(true);
  char const* replacement = m_wanted.isUTF8() ? "\xef\xbf\xbd" : "?";

  if (m_text.isUTF8())
    src.swap(dst);
  else if (!convertToUTF8(src, dst, replacement))
    rc = false;

  if (!isUTF8 && !validateUTF8(dst))
  {
    if (makeValid(dst, replacement) > 0)
      rc = false;
  }

  if (!m_wanted.isUTF8())
  {
    src.swap(dst);
    dst.clear();

    if (!convertFromUTF8(src, dst))
      rc = false;
  }

  text.replace(dst);
  return rc;
}


bool
CharsetConverter::doConversion(TextBuffer& text)
{
  Buffer buf(text);
  return doConversion(buf);
}


bool
CharsetConverter::doConversion(std::string& text)
{
  Buffer buf(text);
  return doConversion(buf);
}

//////////////////////////////////////////////////////////////////////
//  EOF: charsetconverter.cpp
//////////////////////////////////////////////////////////////////////
// vi:set ts=2 sw=2 et:
