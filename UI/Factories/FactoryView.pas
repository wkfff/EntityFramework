unit FactoryView;

interface

uses
  Forms, Sysutils, EnumEntity, Dialogs, ViewBase;

type
  TFactoryForm = class
  private
    class function GetFormClassName(E: TEnumEntities): string; static;
    class procedure ShowForm(Form: TForm; modal: boolean);
  public
    class function GetForm(E: TEnumEntities; modal:boolean = true ):TFormViewBase;
  end;

implementation

uses
InterfaceController, FactoryController, AutoMapper;

class function TFactoryForm.GetFormClassName( E: TEnumEntities):string;
begin
  case E of
     tpCliente   : result:= 'viewCliente.TFormViewCliente';
     tpFornecedor: result:= 'viewFornecedor.TFormViewFornecedor';
     tpFabricante: result:= 'ViewFabricante.TFormViewFabricante';
  else
    begin
      showmessage('Verificar declara��o "initialization RegisterClass" requerido no form !');
      abort;
    end;
  end;
end;

class procedure TFactoryForm.ShowForm(Form:TForm;modal:boolean);
begin
  if modal then
  begin
     Form.showmodal;
     Form.Free;
     Form:= nil;
  end
  else
  begin
    Form.show;
  end;
end;

class function TFactoryForm.GetForm(E: TEnumEntities; modal:boolean = true ):TFormViewBase;
var
  Form          : TFormViewBase;
  Instance      : TObject;
begin
  Instance := TAutoMapper.GetInstance( GetFormClassName( E ) );
  if Instance <> nil then
  begin
    Form := TFormViewBase( Instance ).Create( TFactoryController.GetController( E ) );
    if Form <> nil then
    begin
      ShowForm( Form , modal);
      result:= Form;
    end
    else
      showmessage('Formul�rio n�o implementado!');
  end;
end;

end.
