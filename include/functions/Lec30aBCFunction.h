#pragma once
#include "Function.h"

class Lec30aBCFunction : public Function
{
public:
  static InputParameters validParams();
  Lec30aBCFunction(const InputParameters & parameters);
  
  virtual Real value(Real t, const Point & p) const override;
  
protected:
  
};
