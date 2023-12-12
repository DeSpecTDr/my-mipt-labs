{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  wheel,
  pint,
  pandas,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "pint-pandas";
  version = "0.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hgrecco";
    repo = "pint-pandas";
    rev = version;
    hash = "sha256-1+/elViJIBVO4rcZJHHr4JqwhbJscDvw2eUvKLvEzPA=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    pint
    pandas
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Pandas support for pint";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint-pandas";
    maintainers = with maintainers; [doronbehar];
  };
}
