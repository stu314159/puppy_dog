#pragma once

#include "ADIntegratedBC.h"

class PDADRobinBC : public ADIntegratedBC
{
public:
  static InputParameters validParams();
  
  PDADRobinBC(const InputParameters & parameters);
  
protected:
  virtual ADReal computeQpResidual() override;

};
