unit RavenTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TRavenTestObject = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Atribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TRavenTestObject.Setup;
begin
end;

procedure TRavenTestObject.TearDown;
begin
end;

procedure TRavenTestObject.Test1;
begin
end;

procedure TRavenTestObject.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TRavenTestObject);
end.
