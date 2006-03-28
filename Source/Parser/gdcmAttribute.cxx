#include "gdcmAttributeFactory.h"
#include "gdcmAttribute.h"
#include "gdcmVM.h"
#include "gdcmVR.h"

#include <string.h>

namespace gdcm
{
class AttributeFactoryInternal
  {
  public:
#if 0
  AttributeFactory<VR::UL,VM::VM1_n> AF_UL;
  AttributeFactory<VR::US,VM::VM1_n> AF_US;
  AttributeFactory<VR::SS,VM::VM1_n> AF_SS;
  AttributeFactory<VR::SL,VM::VM1_n> AF_SL;
  AttributeFactory<VR::FL,VM::VM1_n> AF_FL;
  AttributeFactory<VR::FD,VM::VM1_n> AF_FD;
  AttributeFactory<VR::AT,VM::VM1_n> AF_AT;
#endif
  };

Attribute::Attribute()
{
  VRField = VR::VR_END;
  VMField = VM::VM_END;
  AF = new AttributeFactoryInternal;
}

Attribute::~Attribute()
{
  delete AF;
}

void Attribute::SetVR(VR::VRType vr)
{
  VRField = vr;
}

void Attribute::SetVM(VM::VMType vm)
{
  VMField = vm;
}

void Attribute::SetLength(int len)
{
#if 0
  switch(VRField)
    {
  case VR::UL:
    AF->AF_UL.SetLength(len);
    break;
  case VR::US:
  case VR::US_SS:
    AF->AF_US.SetLength(len);
    break;
  case VR::SS:
    AF->AF_SS.SetLength(len);
    break;
  case VR::SL:
    AF->AF_SL.SetLength(len);
    break;
  case VR::FL:
    AF->AF_FL.SetLength(len);
    break;
  case VR::FD:
    AF->AF_FD.SetLength(len);
    break;
  case VR::AT:
    AF->AF_AT.SetLength(len);
    break;
  default:
    abort();
    }
#endif
}

void Attribute::Read(std::istream &_is)
{
#if 0
  switch(VRField)
    {
  case VR::UL:
    AF->AF_UL.Read(_is);
    break;
  case VR::US:
  case VR::US_SS:
    AF->AF_US.Read(_is);
    break;
  case VR::SS:
    AF->AF_SS.Read(_is);
    break;
  case VR::SL:
    AF->AF_SL.Read(_is);
    break;
  case VR::FL:
    AF->AF_FL.Read(_is);
    break;
  case VR::FD:
    AF->AF_FD.Read(_is);
    break;
  case VR::AT:
    AF->AF_AT.Read(_is);
    break;
  default:
    abort();
    }
#endif
}

//void Attribute::SetValue(const char *val)
//{
//  size_t len = strlen(val);
//  if( len )
//    {
//    char *value = new char[len+1];
//    memcpy(value, val, len);
//    delete[] Value;
//    Value = value;
//    Value[len] = '\0';
//    }
//  else
//    {
//    delete[] Value;
//    Value = 0;
//    }
//}
void Attribute::Print(std::ostream &_os) const
{
#if 0
  switch(VRField)
    {
  case VR::UL:
      AF->AF_UL.Print(_os);
      break;
  case VR::US:
  case VR::US_SS:
      AF->AF_US.Print(_os);
      break;
  case VR::SS:
      AF->AF_SS.Print(_os);
      break;
  case VR::SL:
      AF->AF_SL.Print(_os);
      break;
  case VR::FL:
      AF->AF_FL.Print(_os);
      break;
  case VR::FD:
      AF->AF_FD.Print(_os);
      break;
  case VR::AT:
      AF->AF_AT.Print(_os);
      break;
  default:
      abort();
    }
#endif
}

}
