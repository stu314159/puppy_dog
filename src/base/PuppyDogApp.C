#include "PuppyDogApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
PuppyDogApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  params.set<bool>("use_legacy_initial_residual_evaluation_behavior") = false;
  return params;
}

PuppyDogApp::PuppyDogApp(InputParameters parameters) : MooseApp(parameters)
{
  PuppyDogApp::registerAll(_factory, _action_factory, _syntax);
}

PuppyDogApp::~PuppyDogApp() {}

void 
PuppyDogApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<PuppyDogApp>(f, af, s);
  Registry::registerObjectsTo(f, {"PuppyDogApp"});
  Registry::registerActionsTo(af, {"PuppyDogApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
PuppyDogApp::registerApps()
{
  registerApp(PuppyDogApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
PuppyDogApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  PuppyDogApp::registerAll(f, af, s);
}
extern "C" void
PuppyDogApp__registerApps()
{
  PuppyDogApp::registerApps();
}
