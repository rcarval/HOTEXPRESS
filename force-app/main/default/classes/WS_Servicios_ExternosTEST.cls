@istest(SeeAllData=false)
public class WS_Servicios_ExternosTEST {
    static testMethod void test1() {
        
       WS_Servicios_Externos.ListarRegion();
        WS_Servicios_Externos.ListarComunas();
        
        WS_Servicios_Externos.comunasregion   sec=new WS_Servicios_Externos.comunasregion();
        sec.codigoRegion='207';
           WS_Servicios_Externos.ListarComunassegunregion(sec);
        
        
         WS_Servicios_Externos.AdmisionTO   at=new  WS_Servicios_Externos.AdmisionTO();
        at.CodigoAdmision='test';
        at.CentroRemitente='test';
        at.NombreRemitente='test';
        at.DireccionRemitente='test';
        at.PaisRemitente='test';
        at.CodigoPostalRemitente='test';
        at.ComunaRemitente='test';
        at.RutRemitente='test';
        at.PersonaContactoRemitente='test';
        at.TelefonoContactoRemitente='test';
        at.ClienteDestinatario='test';
        at.CentroDestinatario='test';
        at.NombreDestinatario='test';
        at.DireccionDestinatario='test';
        at.PaisDestinatario='test';
        at.CodigoPostalDestinatario='test';
        at.ComunaDestinatario='test';
        at.RutDestinatario='test';
        at.PersonaContactoDestinatario='test';
        at.TelefonoContactoDestinatario='test';
        at.CodigoServicio='test';
        at.NumeroTotalPiezas=1;
        at.Kilos=1;
        at.Volumen=1;
        at.NumeroReferencia='test';
        at.ImporteReembolso=1;
        at.ImporteValorDeclarado=1;
        at.TipoPortes='test';
        at.Observaciones='test';
        at.Observaciones2='test';
        at.EmailDestino='test';
        at.TipoMercancia='test';
        at.DevolucionConforme='test';
        at.NumeroDocumentos=1;
        at.PagoSeguro='test';
        
        WS_Servicios_Externos.admicionCEP(at);
        
       
       
    }
}