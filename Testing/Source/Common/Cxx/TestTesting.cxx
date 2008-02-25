/*=========================================================================

  Program: GDCM (Grass Root DICOM). A DICOM library
  Module:  $URL$

  Copyright (c) 2006-2008 Mathieu Malaterre
  All rights reserved.
  See Copyright.txt or http://gdcm.sourceforge.net/Copyright.html for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/
#include "gdcmTesting.h"

int TestTesting(int argc, char *argv[])
{
  gdcm::Testing testing;
  testing.Print( std::cout );

  const char *f = gdcm::Testing::GetFileName( 100000 );
  if( f ) return 1;

  std::cout << "Num:" << gdcm::Testing::GetNumberOfFileNames() << std::endl;

  return 0;
}