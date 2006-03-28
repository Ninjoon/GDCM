
#ifndef __gdcmExplicitDataElement_h
#define __gdcmExplicitDataElement_h

#include "gdcmDataElement.h"
//#include "gdcmDICOMIStream.h"
#include "gdcmDICOMOStream.h"

namespace gdcm
{
// Data Element (Explicit)
/**
 * \brief Class to represent an *Explivit VR* Data Element
 * \note bla
 */
class GDCM_EXPORT ExplicitDataElement : public DataElement
{
public:
  ExplicitDataElement() { Clear(); }

  void Clear() { ValueLengthField = 0; VRField = VR::INVALID; }
  friend std::ostream& operator<<(std::ostream& _os, const ExplicitDataElement &_val);
  friend class DICOMIStream;
  friend DICOMOStream& operator<<(DICOMOStream& _os, const ExplicitDataElement &_val);

  uint32_t GetValueLength() const { return ValueLengthField; }
  void SetValueLength(uint32_t vl) { ValueLengthField = vl; }

  VR::VRType GetVR() const { return VRField; }
  void SetVR(VR::VRType vr) { VRField = vr; }

  uint32_t GetLength() const { return ComputeLength(); }
  uint32_t GetLength() { return ComputeLength(); }
 
  const Value &GetValue() const { return ValueField; }

protected:
  DICOMOStream& Write(DICOMOStream &_os) const;

  uint32_t ComputeLength() const
    {
    assert( ValueLengthField != 0xFFFFFFFF ); //FIXME
    // Nice trick each time VR::GetLength() is 2 then Value Length is coded in 2
    //                                         4 then Value Length is coded in 4
    return TagField.GetLength() + 2*VR::GetLength(VRField) + ValueLengthField;
    }

private:
  // Value Representation
  VR::VRType VRField;
  Value ValueField;
};
//-----------------------------------------------------------------------------
inline std::ostream& operator<<(std::ostream& _os, const ExplicitDataElement &_val)
{
  _os << _val.TagField << " VR=" << _val.VRField;
  _os << "\tVL=" << std::dec << _val.ValueLengthField
      << "\tValueField=[" << _val.ValueField << "]";
  return _os;
}

} // end namespace gdcm

#endif //__gdcmExplicitDataElement_h

