#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function A02MVC()       *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Criar Controle de Transações    *******************************|
    |******************************* Bancárias                        *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  User FUNCTION A02MVC()

    Local oBrowse 
    //1 - Criação do objeto do tipo Browse. 
    oBrowse:= FwmBrowse():New()   
    //2 - Definir qual a tabela que será apresentada no browse. 
    oBrowse:SetAlias('ZZ1') 
    //3 - Definir o titulo ou descrição que será apresentada no Browse. 
    oBrowse:SetDescription("Controle de Transações Bancárias.")
    //4 - Adicionar as Legendas 
    oBrowse:AddLegend("ZZ1_TIPOCC=='1'", "YELLOW"  , "Cliente Exclusivo")
    oBrowse:AddLegend("ZZ1_TIPOCC=='2'", "RED"     , "Cliente Prime")
    oBrowse:AddLegend("ZZ1_TIPOCC=='3'", "BLUE"    , "Cliente Personalizado")
    //5 - Chamar o Menu 
    oBrowse:SetMenuDef('A02MVC')
    //6 - Realizar a ativação do Browse 
    oBrowse:ACTIVATE()
  
  RETURN


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function MenuDef()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |******************************* Criar as Operaçoes disponíveis   *******************************|
    |******************************* para rotina                      *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  Static Function MenuDef()
    Local aRotina := {}
    

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.A02MVC' OPERATION MODEL_OPERATION_VIEW     ACCESS 0 //OPERATION 1        
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.A02MVC' OPERATION MODEL_OPERATION_INSERT   ACCESS 0 //OPERATION 3        
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.A02MVC' OPERATION MODEL_OPERATION_UPDATE   ACCESS 0 //OPERATION 4       
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.A02MVC' OPERATION MODEL_OPERATION_DELETE   ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Legenda'    ACTION 'u_LegMVC02'     OPERATION MODEL_OPERATION_VIEW     ACCESS 0 //OPERATION 6        
          
  Return aRotina 
 

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    User Function LegMVC02()      *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Legenda utilizada na MenuDef    *******************************|
    |******************************* LegMVC02                         *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  User Function LegMVC02()

    Local aLegenda  :={}
    Local cCadastro := "Controle de Transações Bancárias - Aula 02 MVC"

    AADD(alegenda, {"BR_AMARELO"  , "Cliente Exclusivo"         })
    AADD(alegenda, {"BR_VERMELHO" , "Cliente Prime"             })
    AADD(alegenda, {"BR_AZUL"     , "Cliente Personalizado"     })

    BrwLegenda(cCadastro,"legenda", aLegenda)

  RETURN


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function ModelDef()    *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  A função ModelDef define a      *******************************|
    |******************************* regra de negócios propriamente   *******************************|
    |******************************* dita.                            *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/

 Static Function ModelDef()
      
    //Objeto do modelo de Dados
    Local oModel := MPFormModel():New("A02MVCM", , {|oModel| VldTudoOk(oModel) } , {|oModel| SaveModel(oModel)}, {|oModel| ModelCancel(oModel)})     
    //==============================================================================================================
    //MPFORMMODEL():New(<cID >, <bPre >, <bPost >, <bCommit >, <bCancel >)
    //==============================================================================================================
    //oModel:AddGrid
    //*=============================================================================================================
    //As estruturas são objetos que contêm as definiçoes dos dados, necessárias para uso da ModelDef para a ViewDef.
    //Contém: Estrutura dos campos, índices, gatinhos, Regras de preenchimento 
    //==============================================================================================================
    //Objeto da Estrutura ZZ1
    Local oStruZZ1 := FWFormStruct(1,"ZZ1")                                                          
    //Objeto da estrutura ZZ2
    Local OStruZZ2 := FWFormStruct(1, "ZZ2", {|X| Alltrim(x) <> "ZZ2_CODCOR"} )                      
    Local bLinOK    := {|oGridModel| VldLinOK(oGridModel)}
    Local aGatilhos := {}
    Local nx        := 0

    //=================================================================
    //Altera as propriedades dos campos do modelo ( cabeçalho e Grid)
    //=================================================================
    //TIPOS DE SETPROPERTY                                           
    //MODEL_FIELD_VALID - Definir a regra de validação do campo - B  
    //MODEL_FIELD_WHEN - Defini regra de edição do campo - B         
    //MODEL_FIELD_OBRIGAT - Indica se o campo é obrigarório - L      
    //MODEL_FIELD_TAMANHO - Altera o tamnho do campo - N             
    //MODEL_FIELD_DECIMAL - Altera o decimal do campo - N            
    //MODEL_FIELD_INIT - Altera o inicializador padrão do campo - B  
    //MODEL_FIELD_TIPO - Altera o tipo do campo - C                  
    //=================================================================
    oStruZZ1:SetProperty("*"               , MODEL_FIELD_VALID,   {|| .T.}  )
    oStruZZ1:SetProperty("ZZ1_CODIGO"      , MODEL_FIELD_WHEN,    {|| .F.}  )
    oStruZZ1:SetProperty("ZZ1_SALDO"       , MODEL_FIELD_WHEN,    {|| .F.}  )
    oStruZZ1:SetProperty("ZZ1_SALDO"       , MODEL_FIELD_OBRIGAT,      .F.  )
    oStruZZ2:SetProperty("ZZ2_ITEM"        , MODEL_FIELD_WHEN,    {|| .F.}  )
    oStruZZ2:SetProperty("ZZ2_TIPO"        , MODEL_FIELD_INIT,    {|oModel| IIF(oModel:GetId() == 'ZZ2_GRIDc', '1','2') }  )

    // Adicionando um gatilho 
    aAdd(aGatilhos, FWStruTriggger( "ZZ1_TIPOCC",;                                              //Campode Origem 
    "ZZ1_CHQESP",;                                                                              //Campo Destino           
    "IIF(FwFldGet('ZZ1_TIPOCC')=='1' ,2000,IIF(FwFldGet('ZZ1_TIPOCC')=='2',4000,10000))",;      //Regra de Preenchimento        
    .F.,;                                                                                       //Irá Posicionar?       
    "",;                                                                                        //Alias de Posicionamento           
    0,;                                                                                         //Índice de Posicionamento  
    '',;                                                                                        //Chave de Posicionamento           
    NIL,;                                                                                       //Condição para execução do gatilho        
    "01");                                                                                      //Sequência do gatilho          
    )

    //Percorrendo os gatilhos e adicionando na Struct 
    For nx := 1 To Len(aGatilhos)
      oStruzz1:AddTrigger(aGatilhos[nx][01],;//Campo Origem
      aGatilhos[nx][02],;                    //Campo Destino
      aGatilhos[nx][03],;                    //Bloco de código na validação da execução do gatilho 
      aGatilhos[nx][04])                     //Bloco de código de execução do gatilho 
    Next

    //Criar entidade do Cabeçalho do cadastro 
    //Adiciona ao modelo um componente do tipo formulario
    oModel:AddFields('ZZ1_TOPO',/*owner*/,oStruZZ1) 
    //Defindo a chave primaria da entidade                           
    oModel:GetModel('ZZ1_TOPO'):SetPrimaryKey({'ZZ1_FILIAL','ZZ1_CODIGO'})    

    //Criar entidade da Grid do Cadastro 
    //Crédito
    //Cria uma entidade da Grid, relacionada com a entidade enchoice ou do formulario ou do topo 
    oModel:AddGrid('ZZ2_GRIDc', 'ZZ1_TOPO',oStruZZ2, {|oModelGrid, nLine,cAction, cField | COMP023LPRE(oModelGrid, nLine, cAction, cField)}) 
    oModel:GetModel('ZZ2_GRIDc'):SetOptional(.T.)
    oModel:GetModel('ZZ2_GRIDc'):SetLoadFilter({{"ZZ2_TIPO","'1'"}})

    //Débito
    oModel:AddGrid('ZZ2_GRIDd', 'ZZ1_TOPO', oStruZZ2, , bLinOK,) 
    oModel:GetModel('ZZ2_GRIDd'):SetOptional(.T.)                                                    
    oModel:GetModel('ZZ2_GRIDd'):SetLoadFilter({{"ZZ2_TIPO","'2'"}})

    //Criar relacionamento entre a entidade Pai e Filho 
    oModel:SetRelation('ZZ2_GRIDc',{ {"ZZ2_FILIAL", "xFilial('ZZ2')"} , {"ZZ2_CODCOR", "ZZ1_CODIGO"} },ZZ2->(IndexKey( 1 ) ) )
    oModel:GetModel('ZZ2_GRIDc'):SetUniqueLine({'ZZ2_ITEM','ZZ2_TIPO'})

    oModel:SetRelation('ZZ2_GRIDd',{ {"ZZ2_FILIAL", "xFilial('ZZ2')"} , {"ZZ2_CODCOR", "ZZ1_CODIGO"} },ZZ2->(IndexKey( 1 ) ) )
    oModel:GetModel('ZZ2_GRIDd'):SetUniqueLine({'ZZ2_ITEM','ZZ2_TIPO'})

    //Definir as descriçoes
    oModel:SetDescription("Controle de Transaçoes - MVC Modelo 2")
    oModel:GetModel("ZZ1_TOPO"):SetDescription('Informaçoes do correntistas')
    oModel:GetModel("ZZ2_GRIDc"):SetDescription('Transações de Crédito')
    oModel:GetModel("ZZ2_GRIDd"):SetDescription('Transações de Débito')
  
    //Criando Validações de acesso as Operações 
    oModel:SetVldActivate({|oModel| VldAcesso(oModel) } )

 RETURN oModel


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function ViewDef()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Contem a construção e definição *******************************|
    |******************************* da View, ou seja, será a         *******************************|
    |******************************* construção da interface.         *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/

Static Function ViewDef()
 Local oView       := NIL
 //Campo Ultilizados na Aba de informação do correntista
 Local cCmpFil1    := "ZZ1_CODIGO|ZZ1_NOME|ZZ1_CEL|ZZ1_TEL|"   
 //Campo Ultilizados na Aba de informação de conta corrente                                        
 Local cCmpFil2    := "ZZ1_AGENC|ZZ1_CC|ZZ1_TIPOCC|ZZ1_SALDO|ZZ1_CHQESP|"         
 //Criar o Objeto do Modelo de Dados Baseado no ModelDef informada                    
 Local oModel      := FwLoadModel('A02MVC')          
 //Cria a estrutura de campos do cabeçalho                                                   
 Local oStruZZ1_1  := FWFormStruct(2, 'ZZ1', {|X| Alltrim(x) + "|" $ cCmpFil1 } )                 
 //Cria a estrutura de campos da Grid      
 Local oStruZZ1_2  := FWFormStruct(2, 'ZZ1', {|X| Alltrim(x) + "|" $ cCmpFil2 } )                     
 Local oStruZZ2c   := FWFormStruct(2, 'ZZ2')
 Local oStruZZ2d   := FWFormStruct(2, 'ZZ2')

 //1 - Criar o objeto view e Relacionando com o modelo de dados carregado 
 oView:= FwFormView():New()
 oView:SetModel(oModel) 
 
 //2 - Criad entidade para os campos do Cabeçalho e da Grid 
 oView:AddField("VIEW_ZZ1_1" ,   oStruZZ1_1 , 'ZZ1_TOPO' )   //Cabeçalho - Aba Informação correntistas 
 oView:AddField("VIEW_ZZ1_2" ,   oStruZZ1_2 , 'ZZ1_TOPO' )   //Cabeçalho - Aba Informação conta corrente
 oView:AddGrid("VIEW_ZZ2c"   ,   oStruZZ2c  , 'ZZ2_GRIDc')   // Grid de crédito 
 oView:AddGrid("VIEW_ZZ2d"   ,   oStruZZ2d  , 'ZZ2_GRIDd')   // Grid de débito 

 //3 - Criar os "Box" que irão conter as entidade do cabeçalho e da Grid
 oView:CreateHorizontalBox("CABEC", 30)
 oView:CreateHorizontalBox("GRID" , 70)

 //4 - Hbilitar Título 
 oView:EnableTitle('VIEW_ZZ1_1' ,  "Correntistas"          )
 oView:EnableTitle('VIEW_ZZ1_2' ,  "Conta Corrente"        )
 oView:EnableTitle("VIEW_ZZ2c"  ,  "Transações de Crédito" )
 oView:EnableTitle("VIEW_ZZ2d"  ,  "Transações de Débito"  )

 //5 - Remover o campo código do correntista da tela 
 oStruZZ2c:RemoveField("ZZ2_CODCOR")
 oStruZZ2d:RemoveField("ZZ2_CODCOR")

 oStruZZ2c:RemoveField("ZZ2_TIPO")
 oStruZZ2d:RemoveField("ZZ2_TIPO")

 //6 - Criar o Folder utilizado no cabeçalho 
 //FOLDER SUPERIOR
 oView:CreateFolder("PASTAS", "CABEC")
 oView:AddSheet('PASTAS', 'ABA01', 'Informação do Correntista')
 oView:AddSheet('PASTAS', 'ABA02', 'Informação do Correntista')

 //FOLDER INFERIOR 
 oView:CreateFolder("PASTA_GRID", "GRID")
 oView:AddSheet('PASTA_GRID', 'ABA_GRIDc', 'Transações de Crédito')
 oView:AddSheet('PASTA_GRID', 'ABA_GRIDd', 'Informação do Débito')

 //7 - Criando nova HorizontalBox para colocar a pasta/Abas
 //HorizontalBox da Parte Superior 
 oView:CreateHorizontalBox("CABEC_01",100, , ,'PASTAS', 'ABA01')
 oView:CreateHorizontalBox("CABEC_02",100, , ,'PASTAS', 'ABA02')

 //HorizontalBox Parte Inferior 
 oView:CreateHorizontalBox('GRIDc',100, , , 'PASTA_GRID','ABA_GRIDc')  // Aba de Crédito 
 oView:CreateHorizontalBox('GRIDd',100, , , 'PASTA_GRID','ABA_GRIDd')  // Aba de Débito

 //8 - Amarrar a view com as box 
 oView:SetOwnerView('VIEW_ZZ1_1' , "CABEC_01" )
 oView:SetOwnerView('VIEW_ZZ1_2' , "CABEC_02" )
 oView:SetOwnerView('VIEW_ZZ2c'  , "GRIDc"    )
 oView:SetOwnerView('VIEW_ZZ2d'  , "GRIDd"    )

 //9 - Deixar o campo da transação (ZZ2_ITEM) autoincremental 
 oView:AddIncrementField('VIEW_ZZ2c', 'ZZ2_ITEM')
 oView:AddIncrementField('VIEW_ZZ2d', 'ZZ2_ITEM')


 //10 - Força o fechamento da janela da confirmação 
 oView:SetCloseOnOk({||.F.})  //.F. deixa a tela aberta e .T. Força o fechamento da tela assim que confirmar 

 ///=======================================================================================================================
 //SetViewAction: Executa uma ação em determinado ponto da View                                                           ||
 //REFRESH - Executa a ação no Refresh da View                                                                            ||
 //BUTTONOK - Execulta a ação no acionamento do botão confirmar da View                                                   ||
 //BUTOONCANCEL -  Executa a ação no acionamento do botão confirmar da View                                               ||
 //DELETELINE - Executa a ação na deleção da linha da grid                                                                ||
 //UNDELETELINE - Execulta a ação da restauração da linha da grid                                                         ||
 //=========================================================================================================================

 //11 - Executa uma função ao clicar no botão cancelar 
 //oView:SetViewAction('BUTTONOK'         , {|oView| MsgInfo("Botão OK Acionado")})
 //oView:SetViewAction('BUTTONCANCEL'     , {|oView| MsgInfo("Botão Cancelar Acionado.")})

 //12 - Cria um Timer paraa execução de uma determinada função 
  //oView:SetTimer(10000, {||MsgInfo("10 Segundos")}) //Função que aparece uma mensagem a cada periodo de tempo 

 Return oView 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function VldAcesso()    *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Impede que o Usuário            *******************************|
    |******************************* exclua um cadastro.              *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/
  
 Static Function VldAcesso(oModel)
    Local nOperation  := oModel:GetOperation()
    Local lRet        := .T. 

  If nOperation == MODEL_OPERATION_DELETE
     lRet := .F. 
     Help(NIL, NIL, "Deletar linha", NIL, "Não permitido deletar linhas", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apenas mudança de status é permitido"})
  Endif
 
 Return lRet 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function VldLinOK()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Valida o conteúdo de uma        *******************************|
    |******************************* Linha na grid.                   *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/

Static Function VldLinOK(oModelGrid)
      IF !oGridModel:IsDeleted()

       IF oGridModel:GetValue('ZZ2_VALOR') > 1000 
        lRet := .F. 
     Help( , , 'HELP',, 'Não é possível realizar um saque maior que R$ 1.000,00', 1, 0)
    ENDIF
   
 ENDIF    
 Return lRet
 

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function COMP023LPRE()  *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Impede que o Usuário exclua     *******************************|
    |******************************* a linha da Grid.                 *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/
 /*
 Static Function COMP023LPRE( oModelGrid, nLinha, cAcao, cCampo )
 //Para a Static Function Funcionar Inclua no bloco de código. 
 //oModel:AddGrid('ZZ2_GRIDc', 'ZZ1_TOPO',oStruZZ2, {|oModelGrid, nLine,cAction, cField | COMP023LPRE(oModelGrid, nLine, cAction, cField)})  
 //Cria uma entidade da Grid, relacionada com a entidade enchoice ou do formulario ou do topo 

  Local lRet       := .T.
  Local oModel     := oModelGrid:GetModel()
  Local nOperation := oModel:GetOperation()
  local _Status    := ZRG_STATUS
  // Valida se pode ou não apagar uma linha do Grid
  If cAcao == 'DELETE' .AND. nOperation == MODEL_OPERATION_UPDATE .AND. _Status >= 3
    lRet := .F.
    Help(NIL, NIL, "Deletar linha", NIL, "Não permitido deletar linhas", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Apenas mudança de status é permitido"})
  EndIf

Return lRet
*/

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function VldTudoOk()    *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Valida o Conteúdo do modelo     *******************************|
    |******************************* de dados.                        *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/

Static Function VldTudoOk(oModel)
    Local lRet        := .T.
    Local oModelZZ2c  := oModel:GetModel('ZZ2_GRIDc')
    Local oModelZZ2d  := oModel:GetModel('ZZ2_GRIDd')
    Local nSldCor     := FwFldGet('ZZ1_SALDO')
    Local nVlrChqEs   := 0
    Local nX          := 0 
 
    //CLienrte Exclusivo 
    if FwFldGet('ZZ1_TIPOCC') =='1'  
      nVlrChqEs       := 2000

    //CLienrte Prime  
    ElseIf FwFldGet('ZZ1_TIPOCC') =='2'  
      nVlrChqEs       := 4000

    //Personalizado 
    else                                 
      nVlrChqEs       := 10000
    Endif  

    //Lê as Transações da Grid de Crédito
    For nX := 1 to oModelZZ2c:Length()
      oModelZZ2c:Goline(nX)
      IF !oModelZZ2c:ISEmpty()   .and. !oModelZZ2c:IsDeleted()
             nSldCor += oModelZZ2c:GetValue('ZZ2_VALOR')  
      Endif
    Next

    //Lê as Transações da Grid de Débito 
    For nX := 1 to oModelZZ2d:Length()
      oModelZZ2d:Goline(nX)
      IF !oModelZZ2d:ISEmpty()   .and. !oModelZZ2d:IsDeleted()
             nSldCor -= oModelZZ2d:GetValue('ZZ2_VALOR')  
      Endif
    Next
    
    IF (nSldCor + nVlrChqEs) < 0 
       Help(,, 'HELP',, 'O Limite do correntista foi excedido', 1, 0)
       lRet := .F.
    Endif

Return lRet  


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function ModelCancel()  *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Valida o Conteúdo do modelo     *******************************|
    |******************************* de dados.                        *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/
  
Static Function ModelCancel(oModel)
   local lRet := .T.

   Help( ,, 'HELP',, 'Cancelou a Tansação', 1, 0 )

Return lRet


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function SaveModel()    *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Valida o Conteúdo do modelo     *******************************|
    |******************************* de dados.                        *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/

Static Function SaveModel(oModel)

    Local lRet         := .T.
    Local oModelZZ2c   := oModel:GetModel('ZZ2_GRIDc')
    Local oModelZZ2d   := oModel:GetModel('ZZ2_GRIDd')
    Local nSldCor      := FwFldGet("ZZ1_SALDO")
    Local nOPeration   := oModel:GetOperation()
    Local nX           := 0

    If nOPeration == MODEL_OPERATION_UPDATE .OR. nOPeration == MODEL_OPERATION_INSERT
      //Lê o valor das Transações de CRÉDITO
      For nX := 1 to oModelZZ2c:Length()
        oModelZZ2c:Goline(nX)
        If !oModelZZ2c:IsDeleted() .and. !oModelZZ2c:IsEmpty()
            nSldCor += oModelZZ2c:GetValue('ZZ2_VALOR')
          Endif 
      Next
    Endif

    //Lê o valor das Transações de DÉBITO 
    If nOPeration == MODEL_OPERATION_UPDATE .OR. nOPeration == MODEL_OPERATION_INSERT
      For nX := 1 to oModelZZ2d:Length()
        oModelZZ2d:Goline(nX)
        If !oModelZZ2d:IsDeleted() .and. !oModelZZ2d:IsEmpty()
            nSldCor -= oModelZZ2d:GetValue('ZZ2_VALOR')
        Endif 
      Next

      oModel:LoadValue('ZZ1_TOPO', "ZZ1_SALDO", nSldCor )
    
    Endif

    FwFormCommit(oModel)

Return lRet
