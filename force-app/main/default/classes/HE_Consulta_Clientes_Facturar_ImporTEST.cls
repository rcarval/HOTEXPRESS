@istest(SeeAllData=false)
public class HE_Consulta_Clientes_Facturar_ImporTEST {
static testMethod void test1() {
    
     Account  acc=new Account();
     acc.Name='1211';
     insert acc;
      
     
     Pais__c p=new Pais__c();
     p.Name='ARGENTINA';
     p.Cod_Pais__c='AR';
      
     p.Nombre_Zonas__c='SUR AMERICA 1';
     p.Zona_DHL__c='Zona 1';
     p.Zona_Fedex__c='Zona 1';
     p.Zona_Hot__c='Zona 1';
     insert p;
     
     Direcciones__c d=new Direcciones__c();
     d.Name='direccion test';
     d.Cuenta__c=acc.id;
     d.Direccion__c='isidora goyenechea 3000';
     d.Ciudad__c='Buenos Aires';
     d.Estado_Provincia__c='Buenos Aires';
     d.Codigo_Postal__c='7550653';
     d.Pais__c=p.id;
     insert d;
     
         Solicitud_de_Pickup__c ge=new Solicitud_de_Pickup__c();
        ge.Cuenta__c=acc.id;
        ge.Agente__c='DHL';
        ge.Peso_Cliente__c=8;
        ge.Peso_Agente__c=8;
        ge.Embalaje_HOT__c='cajas'; 
        ge.Telefono_Destinatario__c='+5698765442';
        ge.Fecha_de_Envio__c=system.today();
        ge.Cantidad_de_Paquetes__c=3;
        ge.Largo_cm__c=2;
        ge.Ancho_cm__c=2;
        ge.Alto_cm__c=2;
        ge.Peso_Total__c=8;
        ge.Direccion_Remitente__c=d.id;
        ge.Direccion_de_Entrega__c=d.id;
        ge.Contacto_Destinatario__c='contacto test';
        insert ge;
        Contenido_Importacion_Agente__c  con=new Contenido_Importacion_Agente__c();
         
        con.Importacion_Agente__c=ge.id;
        con.Descripcion__c='vino';
        con.Pais_de_Fabricacion__c =p.id;
        con.Cantidad__c=1;
        con.Unidad_de_Medida__c='Unidades';
        con.Valor_Unitario__c=15;
        insert con;
     
     Costo__c c=new Costo__c();
     c.Name='comvustible';
     insert c;
     
       Costo_Solicitud_Pickup__c cosinp=new Costo_Solicitud_Pickup__c();
        cosinp.Costo__c=c.id;
        cosinp.Valor__c=8;
        cosinp.Solicitud_de_Pickup__c=ge.Id;
        cosinp.Estado__c= 'Pendiente de Facturar';
        insert cosinp;
    system.debug(ge.Total_Costos_sin_Facturar__c);
     
    //  apexPages.Currentpage().getParameters().put('id',dm.Master__c);
    //  ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
     HE_Consulta_Clientes_Facturar_Impor  he=new HE_Consulta_Clientes_Facturar_Impor();  
     he.Obtenerclientes();
     apexPages.Currentpage().getParameters().put('tipo',acc.id);
     he.consultar_rut();
     
 }
}