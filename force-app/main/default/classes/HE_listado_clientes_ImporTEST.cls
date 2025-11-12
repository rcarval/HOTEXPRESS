@istest(SeeAllData=false)
public class HE_listado_clientes_ImporTEST {
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
        ge.Guia_validada__c=true;
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
        
        //  apexPages.Currentpage().getParameters().put('id',dm.Master__c);
        //  ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
        
        apexPages.Currentpage().getParameters().put('FI','01-06-2019');
        apexPages.Currentpage().getParameters().put('FN','01-06-2025');
        apexPages.Currentpage().getParameters().put('V','600');
        apexPages.Currentpage().getParameters().put('td','1');
        apexPages.Currentpage().getParameters().put('tc','');
        apexPages.Currentpage().getParameters().put('ida',acc.id);
        apexPages.Currentpage().getParameters().put('idcon','');
        apexPages.Currentpage().getParameters().put('ps','');
        apexPages.Currentpage().getParameters().put('zon','');
        HE_listado_clientes_Impor  he=new HE_listado_clientes_Impor();   
        he.Obtenerclientes();
        string  datos='[{"id":"0015A000026wpWEQAY","name":"MUNDO DEL VINO ISIDORA","RUT":"96856980-5","comuna":"santiago","direccion":"isidora goyenechea  3000","contadorpendientes":1,"oc":"","comentario":"","listarguias":[{"idguia":"'+ge.id+'","idproducto":"GE-0000000019","pais_destino":"ARGENTINA","tipo":"Mercancías","fecha":"2020-06-17","montoUSD":"297.60","montoCLP":"59520"}]},{"id":"0015A000026wpaNQAQ","name":"VINOS RAVANAL LTDA.","RUT":"76242685-4","comuna":"San Fernando","direccion":"OSCAR GAJARDO S/N Placilla","contadorpendientes":1,"oc":"","comentario":"","listarguias":[{"idguia":"'+ge.id+'","idproducto":"GE-0000000025","pais_destino":"ESTADOS UNIDOS","tipo":"Mercancías","fecha":"2020-06-11","montoUSD":"100.00","montoCLP":"20000"},{"idguia":"'+ge.id+'","idproducto":"GE-0000000022","pais_destino":"ESTADOS UNIDOS","tipo":"Mercancías","fecha":"2020-06-11","montoUSD":"137.22","montoCLP":"27444"}]}]';
        apexPages.Currentpage().getParameters().put('datos',datos);
        he.facrturar();
    
    } 
}