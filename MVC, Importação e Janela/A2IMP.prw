#include 'protheus.ch'
#include 'parmtype.ch'
#include "FWMBROWSE.CH"
#include 'FwMvcDef.ch'


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function A2IMP()        *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Criar os registros de ações     *******************************|
    |******************************* para estudos                     *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

   USER FUNCTION A2IMP()
      Local oBrowse 
      //Criação do objeto  tipo browse
      oBrowse := Fwmbrowse():New()    
      //Definição da tabela que sera utilizada no Browse
      oBrowse:SetAlias('SZ8')  
      //Definição o Título
      oBrowse:setDescription("Estudos de Ações")  
      //Incluindo uma legenda R para reprovado e A para aprovado, assim não sera necessario a utilização de uma condição
      oBrowse:AddLegend("Z8_ESTUDO =='R'","RED", "REPROVADO PARA ESTUDO") 
      //Tendo em mente que o usuário só podera colocar Arpovado e Reprovado.
      oBrowse:AddLegend("Z8_ESTUDO =='A'","GREEN","APROVADO PARA ESTUDO")  
      //Criação de um Filtro
     oBrowse:setFilterDefault("!Empty(Z8_ESTUDO)")   
      //Desabilita o detalhe do registro do Browse
     oBrowse:DisableDetails() 
      //Chamar o Menu 
     oBrowse:SetMenuDef('A2IMP') 
      // Realiza a ativação do browse 
     oBrowse:Activate() 


   RETURN 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function ModelDef()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Modelo de dados criado.         *******************************|
    |*******************************                                  *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

   Static Function ModelDef()
     Local oModel                 
     Local oStruSZ8        
     //Cria o objeto do Modelo de dados 
     oModel := MPFormModel():New('A2IMPO') 
     //Cria uma estrutura que será utilizada no modelo //- Para o modelo de dados 1 -(model) e 2- Para view 
     oStruSZ8 := FWFormStruct(1,"SZ8") 
     //Adiciona ao modelo um componente do tipo formulario 
     oModel:AddFields('SZ8_TOPO',/*OWNER*/,oStruSZ8) 
     //Defini a descrição do model
     oModel:SetDescription("Ações - Cadastro de ações")  
     //Definindo a descrição do componente formulario
     oModel:GetModel("SZ8_TOPO"):SetDescription('Dados do Produto')
     //definir a primaryKey do modelo
     oModel:SetPrimarykey({'Z8_FILIAL', 'Z8_ACAO'})  
   // Rorna o Modelo de dados 
   Return oModel  

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function ViewDef()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Contem a construção e definição *******************************|
    |******************************* da View, ou seja, será a         *******************************|
    |******************************* construção da interface.         *******************************|
    |*******************************==================================*******************************|
    \ ***********************************************************************************************/


   Static Function ViewDef()
     Local oModel   
     Local oStruSz8   
     Local oView       

     // - Criar o objeto do Modelo de dados baseado no ModelDef do fonte informado.
     oModel := FwLoadModel('A2IMP') 
     // - Tipo de Estrutura (1-Model ou 2-View)
     oStruSz8 := FWFormStruct(2, "SZ8") 
     // - Criar o objeto da View
     oView := FwFormView():New() 
     // - Define qual é o modelo de dados que será  utilizado na View.
     oView:SetModel(oModel)  
     // - Adiciona no View um componente do tipo Formulário (Enchoice), amarrando o formulario da View com o formulário do Modelo
     oView:AddField("SZ8_TOP",oStruSz8, 'SZ8_TOPO') 
     // - Criar um "box" Horizontal para receber um elemento da View.
     oView:CreateHorizontalBox("FORMULARIO", 100)  
     // - Relacionar o "box " com a View criada para exibição
     oView:SetOwnerView("SZ8_TOP", 'FORMULARIO')  
   // - Retorna o objeto View criado pela função 
   Return oView 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************    Static Function MenuDef()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |******************************* Criar as Operaçoes disponíveis   *******************************|
    |******************************* para rotina                      *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

   Static Function MenuDef()
     Local aRotina := {}
         
     ADD OPTION aRotina TITLE 'Importar'   ACTION 'U_IMPORT2'     OPERATION MODEL_OPERATION_INSERT   ACCESS 0 //OPERATION 6 
     ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.A2IMP' OPERATION MODEL_OPERATION_INSERT   ACCESS 0 //OPERATION 3        
     ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.A2IMP' OPERATION MODEL_OPERATION_VIEW     ACCESS 0 //OPERATION 1 
     ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.A2IMP' OPERATION MODEL_OPERATION_UPDATE   ACCESS 0 //OPERATION 4       
     ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.A2IMP' OPERATION MODEL_OPERATION_DELETE   ACCESS 0 //OPERATION 5
     ADD OPTION aRotina TITLE 'E-mail'     ACTION 'U_JAM01'       OPERATION MODEL_OPERATION_INSERT   ACCESS 0 //OPERATION 6 
    
   Return aRotina
