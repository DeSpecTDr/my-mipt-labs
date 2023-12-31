{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  # build-system
  setuptools,
  setuptools-scm,
  # propagates
  typing-extensions,
  # tests
  pytestCheckHook,
  pytest-subtests,
  numpy,
  matplotlib,
  uncertainties,
}:
buildPythonPackage rec {
  pname = "pint";
  version = "0.23rc0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "Pint";
    hash = "sha256-lBSpY8ZUdcx4vNyQRWBW7mkgNphnv1QV0/0JhEX6NgQ=";
  };

  doCheck = false;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-subtests
    numpy
    matplotlib
    uncertainties
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # https://github.com/hgrecco/pint/issues/1825
    "test_equal_zero_nan_NP"
  ];

  meta = with lib; {
    changelog = "https://github.com/hgrecco/pint/blob/${version}/CHANGES";
    description = "Physical quantities module";
    license = licenses.bsd3;
    homepage = "https://github.com/hgrecco/pint/";
    maintainers = with maintainers; [doronbehar];
  };
}
