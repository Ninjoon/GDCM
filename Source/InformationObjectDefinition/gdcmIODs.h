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
#ifndef __gdcmIODs_h
#define __gdcmIODs_h

#include "gdcmTypes.h"
#include "gdcmIOD.h"

#include <map>

namespace gdcm
{
/**
 * \brief Class for representing a IODs
 * \note bla
 * \sa IOD
 */
class GDCM_EXPORT IODs
{
public:
  typedef std::map<std::string, IOD> IODMapType;

  IODs() {}
  friend std::ostream& operator<<(std::ostream& _os, const IODs &_val);

  void Clear() { IODsInternal.clear(); }

  void AddIOD(const char *name , const IOD & module )
    {
    IODsInternal.insert(
      IODMapType::value_type(name, module));
    }
  const IOD &GetIOD(const char *name) const
    {
    //return IODsInternal[name];
    IODMapType::const_iterator it = IODsInternal.find( name );
    assert( it->first == name );
    return it->second;
    }

private:
  IODMapType IODsInternal;
};
//-----------------------------------------------------------------------------
inline std::ostream& operator<<(std::ostream& _os, const IODs &_val)
{
  IODs::IODMapType::const_iterator it = _val.IODsInternal.begin();
  for(;it != _val.IODsInternal.end(); ++it)
    {
    const std::string &name = it->first;
    const IOD &m = it->second;
    _os << name << " " << m << '\n';
    }

  return _os;
}


} // end namespace gdcm

#endif //__gdcmIODs_h
