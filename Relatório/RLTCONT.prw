#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function A2IMP()        *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Valida as perguntas do          *******************************|
    |*******************************  relatório                       *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

		User Function RLTCONT()
	    	Private _oReport := Nil 
        Private _oContr  := Nil 
        Private _oIten   := Nil 
        Private cPerg   := "CON_FRE"


        ValidPerg()
        Pergunte(cPerg, .T.)

        ReportDef()
        oReportDef()
        //Exibe a tela de configuração para a impressão do relatório
        _oReport:PrintDialog()
        Return 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     Static Function ReportDef()  *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Monta o relatório de contratos  *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/
Static Function ReportDef()

//TReport():New()
//1° Parâmetro <Nome do relatório> 
//2° Parâmetro <Título do relatório> 
//3° Parâmetro <Perguntas> 
//4° Parâmetro <Bloco de código que será executado quando o usuário confirmar a impressão do relatório> ,
//5° Parâmetro <Descrição>
_oReport :=TReport():New("CON_FRE", "Relatório - Contrato de Freezer",cPerg, {|_oReport| PrintReport(_oReport)},"Relatório")
//Define a orientação de página do relatório como Paisagem
_oReport  :SetLandscap(.T.)
//TRSection é o layout do relatório, por conter células, quebras e totalizadores que darão um formato para sua impressão.
//TRSection():New( 
//1° <Objeto da classe TReport>
//2° <Título da seção>
//3° <Tabela>
_oContr := TRSection():New(_oReport,"CONTRATOS DE FREEZE",{"ZRG"} )

	TRCell():New(_oContr  ,     "ZRG_CLIENT"  ,     "ZRG"   ,     "CLIENTE"     ,"@!"   ,   40   ,   .F.)
	TRCell():New(_oContr  ,     "ZRG_NRCTRA"  ,     "ZRG"   ,     "N CONTRATO"  ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oContr  ,     "ZRG_CODSC5"  ,     "ZRG"   ,     "PEDIDO"      ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oContr  ,     "ZRG_NFREME"  ,     "ZRG"   ,     "NF REMESSA"  ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oContr  ,     "ZRG_INICIO"  ,     "ZRG"   ,     "DT INICIO"   ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oContr  ,     "ZRG_FIM"     ,     "ZRG"   ,     "DT FIM"      ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oContr  ,     "ZRG_STATUS"  ,     "ZRG"   ,     "STATUS"      ,"@!"   ,   25   ,   .F.)


 _oIten := TRSection():New(_oReport,"ITENS DO CONTRATO",{"ZRH"} )

	TRCell():New(_oIten   ,"ZRH_PRODUT"       ,     "ZRH"   ,     "PRODUTO"     ,"@!"   ,   40   ,   .F.)
	TRCell():New(_oIten   ,"ZRH_SRPROD"       ,     "ZRH"   ,     "N SERIE"     ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oIten   ,"ZRH_PLACA"        ,     "ZRH"   ,     "PLAQUETA"    ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oIten   ,"ZRH_INICIO"       ,     "ZRH"   ,     "DT INICIO"   ,"@!"   ,   25   ,   .F.)
	TRCell():New(_oIten   ,"ZRH_FIM"          ,     "ZRH"   ,     "DT FIM"      ,"@!"   ,   25   ,   .F.)



  Return _oReport


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function PrintReport() *******************************|
    |*******************************    @author Gustavo Krebs         *******************************|
    |*******************************    @since 10/01/2021             *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Monta a Query para buscar as    *******************************|
    |******************************* informações do relatório         *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

Static Function PrintReport(_oReport)
 Local _cAlias := GetNexAlias()

_oContr:BeginQuery()

beginSql Alias _cAlias

    _cQuery := "Select, "         +CRLF
	  _cQuery := "ZRG.ZRG_CLIENT,"  +CRLF 
		_cQuery := "ZRG.ZRG_NRCTRA,"  +CRLF 
		_cQuery := "ZRG.ZRG_CODSC5,"  +CRLF 
		_cQuery := "ZRG.ZRG_NFREME,"  +CRLF
		_cQuery := "ZRG.ZRG_INICIO,"  +CRLF 
		_cQuery := "ZRG.ZRG_FIM,"     +CRLF
		_cQuery := "ZRH.ZRH_PRODUT,"  +CRLF
		_cQuery := "ZRH.ZRH_SRPROD,"  +CRLF 
		_cQuery := "ZRH.ZRH_PLACA, "  +CRLF 
		_cQuery := "ZRH.ZRH_INICIO,"  +CRLF 
		_cQuery := "ZRH.ZRH_FIM "     +CRLF 
		_cQuery += "FROM "+RETSQLNAME("ZRG")+ " ZRG " +CRLF 
		_cQuery += "LEFT JOIN "+RETSQLNAME("ZRH")+ "ZRH010 ZRH on ZRH.D_E_L_E_T_ = ' ' And ZRH.ZRH_FILIAL = ZRG.ZRG_FILIAL And ZRG.ZRG_NRCTRA = ZRH.ZRH_NRCTRA  "
		_cQuery += "WHERE ZRG.D_E_L_E_T_ = ' '" +CRLF 
		_cQuery += "AND ZRG.ZRG_NRCTRA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" +CRLF 
		_cQuery += "ORDER BY ZRG_NRCTRA,ZRH_NRCTRA "+CRLF 

		
   EndSql 

    _oContr:EndQuery() //Fim da Query 
    _oIten:SetParentQuery()
    _oIten:SetParentFilter({|cForLoja| (cAlias)->ZRG_CLIENT+(cAlias)->ZRG_NRCTRA = cForLoja},{|| (cAlias)->ZRG_CLIENT+(cAlias)->ZRG_NRCTRA})
    _oContr:Print()

    (cAlias)->(DbCloseArea())

Return 

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function PrintReport() *******************************|
    |*******************************    @author Gustavo Krebs         *******************************|
    |*******************************    @since 10/01/2021             *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Valida as perguntas             *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/
Static Function ValidPerg()
   Local aArea := SX1 ->(GetArea())
   Local aRegs := {}
   Local _i, _j 

   aadd( aRegs, {cPerg, "01","Contrato de ?", "Contrato de ?", "Contrato de ?", "mv_ch1", "C", 6,0,0,"G","","","mv_par01" })
   aadd( aRegs, {cPerg, "01","Contrato Ate ?", "Contrato Ate ?", "Contrato Ate ?", "mv_ch2", "C", 6,0,0,"G","","","mv_par02" })

 DbselectArea('SX1')
 SX1->(DBSETORDER(1))
 For _i:= 1 To Len(aRegs)
   If ! SX1->(DBSEEK( AvKey(cPerg, "X1_GRUPO")+ aregs[_i,2]))
    Reclock('SX1', .T.)
    For _j:= 1 To SX1->( FCOUNT())
        If j <= Len(aRegs[_i])
           FieldPut(j, aRegs[_i,_j])
        Endif 
    Next _j
    SX1->(MsUnlock())
    Endif 
 Next _i 
  RestArea(aArea)
  Return(cPerg)
