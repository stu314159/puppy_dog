#pragma once
#include "Function.h"

class Lec30nRHSFunction : public Function
{
public:
  static InputParameters validParams();
  Lec30nRHSFunction(const InputParameters & parameters);
  
  virtual Real value(Real t, const Point & p) const override;
  
protected:
  Real _Q;
  Real _R;
};
