//////////////////////////////////////////////////////////////////////
//
//  FILE:       win_mmap.h
//              Fast file read access for Windows.
//
//  Part of:    Scid (Shane's Chess Information Database)
//  Version:    2.0
//
//  Notice:     Copyright (c) 2014  Gregor Cramer.
//
//  Author:     Gregor Cramer
//
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
//
// Only useful for fast sequential read of a whole file.
//
// This class is for Windows only.
//
//////////////////////////////////////////////////////////////////////

#ifndef SCID_WIN_MMAP_H
#define SCID_WIN_MMAP_H

#include <windows.h>

class WinMMap
{
public:

    WinMMap(char const* filename);
    ~WinMMap();

    bool isOpen() const { return m_address != NULL; }

    unsigned size() const { return m_size; }

    unsigned char const* address() const { return static_cast<unsigned char const*>(m_address); }

private:

    void*     m_address;
    unsigned  m_size;
    HANDLE    m_file;
    HANDLE    m_mapping;
};


inline
WinMMap::WinMMap(char const* filename)
    :m_address(0)
    ,m_size(0)
    ,m_file(INVALID_HANDLE_VALUE)
    ,m_mapping(INVALID_HANDLE_VALUE)
{
    ASSERT (filename != NULL);

    // Using FILE_SHARE_READ | FILE_SHARE_WRITE
    // enables success mingw-w64 32 compilers, but creates a nasty conflict on mingw-64 64 bit compilers.
    // Since mingw does not have a 60 bit compiler, we probably need VCC to make this work
    // But not really an issue as modern windows systems have fast file accesses anyway.
    m_file = CreateFileA(
					filename,
					GENERIC_READ,
					0, // FILE_SHARE_READ | FILE_SHARE_WRITE 
					0,
					OPEN_EXISTING,
					FILE_FLAG_SEQUENTIAL_SCAN | FILE_ATTRIBUTE_READONLY | FILE_ATTRIBUTE_TEMPORARY,
					0);

    if (m_file == INVALID_HANDLE_VALUE)
        return;

    m_mapping = CreateFileMappingA(
						 m_file,
						 0,
						 PAGE_READONLY,
						 0,
						 0,
						 filename);

    if (m_mapping == INVALID_HANDLE_VALUE)
        return;

    m_address = MapViewOfFile(m_mapping, FILE_MAP_READ, 0, 0, 0);
    m_size = GetFileSize(m_file, 0);
}


inline
WinMMap::~WinMMap()
{
    if (m_address)
        UnmapViewOfFile(m_address);

    if (m_mapping != INVALID_HANDLE_VALUE)
        CloseHandle(m_mapping);

    if (m_file != INVALID_HANDLE_VALUE)
        CloseHandle(m_file);
}

#endif  // SCID_WIN_MMAP_H

//////////////////////////////////////////////////////////////////////
//  End of file: win_mmap.h
//////////////////////////////////////////////////////////////////////
