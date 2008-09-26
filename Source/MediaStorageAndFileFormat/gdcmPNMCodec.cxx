/*=========================================================================

  Program: GDCM (Grassroots DICOM). A DICOM library
  Module:  $URL$

  Copyright (c) 2006-2008 Mathieu Malaterre
  All rights reserved.
  See Copyright.txt or http://gdcm.sourceforge.net/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/
#include "gdcmPNMCodec.h"
#include "gdcmTransferSyntax.h"
#include "gdcmSystem.h"
#include "gdcmDataElement.h"
#include "gdcmSequenceOfFragments.h"

namespace gdcm
{

PNMCodec::PNMCodec():BufferLength(0)
{
}

PNMCodec::~PNMCodec()
{
}

bool PNMCodec::CanDecode(TransferSyntax const &ts) const
{
  return false;
}

bool PNMCodec::CanCode(TransferSyntax const &ts) const
{
  return false;
}



bool PNMCodec::Write(const char *filename, const DataElement &out) const
{
  std::ofstream os(filename);
  const unsigned int *dims = this->GetDimensions();
  os << "P5\n";
  os << dims[0] << " " << dims[1] << "\n";
  
  const PixelFormat& pf = GetPixelFormat();
  switch(pf)
    {
  case PixelFormat::UINT8:
    os << "255";
    break;
  case PixelFormat::UINT16:
    os << "65535";
    break;
  default:
    gdcmErrorMacro( "Unhandled PF: " << pf );
    }
  os << "\n";

  const gdcm::ByteValue *bv = out.GetByteValue();
  assert(bv);
  bv->WriteBuffer( os );

  os.close();


  return true;
}

bool PNMCodec::Read(const char *filename, DataElement &out) const
{
  size_t len = gdcm::System::FileSize(filename);
  std::ifstream is(filename);
  std::string type, str;
  std::getline(is,type);
  gdcm::PhotometricInterpretation pi;
  if( type == "P5" )
    pi = gdcm::PhotometricInterpretation::MONOCHROME2;
  else if( type == "P6" )
    pi = gdcm::PhotometricInterpretation::RGB;
  else 
    {
    std::cerr << "Unhandled PGM type: " << type << std::endl;
    return false;
    }

  // skip comments:
  while( is.peek() == '#' )
    {
    std::getline(is, str);
    //std::cout << str << std::endl;
    }
  unsigned int dims[3] = {};
  is >> dims[0]; is >> dims[1];
  unsigned int maxval;
  is >> maxval;
  // some kind of empty line...
  while( is.peek() == '\n' )
    {
    is.get();
    }
  std::streampos pos = is.tellg();
  size_t m = (len - pos ) / ( dims[0]*dims[1] );
  if( m * dims[0] * dims[1] != len - pos )
    {
    std::cerr << "Problem computing length" << std::endl;
    return false;
    }
  gdcm::PixelFormat pf;
  switch(maxval)
    {
  case 255:
    pf = gdcm::PixelFormat::UINT8;
    break;
  case 1023:
    pf = gdcm::PixelFormat::UINT12;
    break;
  case 4095:
    pf = gdcm::PixelFormat::UINT12;
    break;
  case 32767: // int16 ?
    pf = gdcm::PixelFormat::UINT16;
    break;
  case 65535:
    pf = gdcm::PixelFormat::UINT16;
    break;
  default:
    std::cerr << "Unhandled max val: " << maxval << std::endl;
    return false;
    }
  if( pi == gdcm::PhotometricInterpretation::RGB )
    {
    pf.SetSamplesPerPixel( 3 );
    }
  //if ( maxval * 8 != bpp ) return 1;

    size_t pdlen = GetBufferLength();
assert( pdlen );
    char * buf = new char[pdlen];
    // is should be at right offset, just read!
    is.read(buf, len);
    if( !is.eof() ) return 1;

    out.SetTag( gdcm::Tag(0x7fe0,0x0010) );
    out.SetByteValue( buf, pdlen );
    delete[] buf;
    
is.close();

  return true;
}


} // end namespace gdcm