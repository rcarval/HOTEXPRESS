#!/bin/bash

# Script para abrir directamente la página de Outbound Change Sets
# Uso: ./scripts/open_changeset_page.sh

echo "🚀 Abriendo página de Outbound Change Sets en HOTEXPRESS-DEV..."

# Obtener la URL de la org
sf org open --target-org HOTEXPRESS-DEV --path "/changemgmt/listOutboundChangeSet.apexp"

echo ""
echo "📋 Componentes a agregar manualmente al Change Set 'Ticket_00024535':"
echo ""
echo "  Apex Classes:"
echo "    • HE_Subir_Documento"
echo "    • HE_Subir_DocumentoTEST"
echo ""
echo "  Visualforce Pages:"
echo "    • HE_Subir_Documento"
echo ""
echo "  Custom Fields:"
echo "    • Detalles Master > Estado Aduana (Estado_Aduana__c)"
echo ""
echo "💡 Tip: Usa 'Add' → 'View/Add Dependencies' para asegurar que se incluyan todos los componentes necesarios"
echo ""

