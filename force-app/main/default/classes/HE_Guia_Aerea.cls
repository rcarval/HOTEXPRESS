public class HE_Guia_Aerea {
    public  Detalles_Master__c  dm{get;set;}
    // public  string   fecha{get;set;}
    public  date fecha{get;set;}
    public String fechaFormateada { get; set; }
    public string idDetMasT {get;set;}
       public HE_Guia_Aerea(ApexPages.StandardController controller){
      idDetMasT=controller.getId(); 
    }
    public string cargar(){
        dm=[SELECT Id, Name, Master__c,Master__r.Master_AirwayBill__c,Master__r.N_Manifiesto_Aduana__c,
            Master__r.Fecha_Manifiesto_Aduana__c,Master__r.Aeropuerto_Origen__c,Master__r.N_Vuelo__c, Vendedor__c,
            Consignatario__c, Direccion_Consignatario__c, Comuna__c, Pieces__c, Peso__c,
            Valor__c, Descripcion__c, Rut_Consignatario__c, Enviado_a_Correo__c, 
            Bag_Code__c, DIP_Confecionada__c, Estado_Cliente__c, Seguro__c, Flete__c, Direccion_Normalizada__c 
            FROM Detalles_Master__c 
            WHERE Id =: idDetMasT];
        fecha=null;
        fechaFormateada = null;
        if(dm.Master__r.Fecha_Manifiesto_Aduana__c!=null){
            //datetime  fechahora= dm.Master__r.Fecha_Manifiesto_Aduana__c;
            // fecha=  fechahora.format('dd/MM/YYYY');
            fecha = dm.Master__r.Fecha_Manifiesto_Aduana__c;
            String dia = String.valueOf(fecha.day());
            String mes = String.valueOf(fecha.month());
            String ano = String.valueOf(fecha.year());

            // Agrega un "0" antes si el día o el mes tienen un solo dígito
            if (dia.length() == 1) {
                dia = '0' + dia;
            }
            if (mes.length() == 1) {
                mes = '0' + mes;
            }

            fechaFormateada = dia + '/' + mes + '/' + ano;
        }
        return null;
    }
}