/*********************************************************************************************************************
Desarrollado por: Seidor
Autor: Roberto Quiroz Gonzalez (RQG)
Proyecto: HotExpress
Descripción: 
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 24-01-2022            RQG                      Creación de la Clase que guarda adjunto para DHl y Fedex
**********************************************************************************************************************/
public class HE_AttachmentGuides {

    //crea un adjunto
    public static void saveAttachment(string parentId, string encode, string fileName){       
        
        Attachment attachment = new Attachment();
        attachment.Body = EncodingUtil.base64Decode(encode); //Blob.valueOf(encode);
        attachment.Name = fileName;
        attachment.ParentId = parentId; 
        insert attachment;
    }
}