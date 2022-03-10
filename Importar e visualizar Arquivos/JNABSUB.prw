#include "totvs.ch"
#include "protheus.ch"
#include 'fileio.ch'


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function JNABSUB()      *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Interface para abrir o arquivo  *******************************|
    |******************************* que foi anexado pela função      *******************************|
    |******************************* Anex01 ou  Substituir o mesmo    *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/ 

User function JNABSUB()

	Local _oDlg := FwDialogModal():New()

	// Se não ouver nem um dado no campo A1_MEMO o campo que armazena o arquivo (Não será possível continuar com a condição.)
	If EMPTY(SA1->A1_EXTEN)
		Alert("Não possuí contrato")
		Return
	Else

	//Janela onde apresentara as funções de visualizar os arquivos e subistituir o arquivo atual
		_oDlg:SetTitle('Dados de Contrato')
		_oDlg:SetSize(080,100)
		_oDlg:CreateDialog()
		_oPnl := _oDlg:GetPanelMain()
		
		//Abrir o arquivo
		oTBtnBmp1 := TBtnBmp2():New( 05, 10, 35, 25, 'VERNOTA',,,, { ||Visuanex( 'Abrir' ) }, _oPnl, 'Abrir Contrato',, .F., .F. )
		@ 005,020 SAY "Visualizar arquivo  "    SIZE 150,007 OF _oPnl PIXEL

		//Subistituir o arquivo
		oTBtnBmp1 := TBtnBmp2():New( 42, 10, 35, 25, 'CTBREPLA',,,, { ||U_Anex02( 'Substituir' ) }, _oPnl, 'Substituir contrato',, .F., .F. )
		@ 025,021 SAY "Substituir o arquivo "    SIZE 150,007 OF _oPnl PIXEL
		//Fechar a janela
		_oDlg:addCloseButton({||_oDlg:OOWNER:END()} )

		_oDlg:Activate()
	Endif
Return


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function Visuanex()     *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que Converte uma string  *******************************|
    |******************************* contendo um buffer codificado em *******************************|
    |******************************* BASE64 para o seu formato        *******************************|
	|******************************* original                         *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/ 

Static Function Visuanex(oSay)

	local _aSA1       := SA1->(GetArea())
	Local _cAbrir    := ""
	Local _cDeco     := "" 
	Local _cLocal    := ""
	Local _cExten    := "" 
	Local _cDestino  := ""
	Local _Nome      := "Nome"


	//Local onde o arquivo sera salvo, no caso a função GetTempPath() ira encontrar o diretório temporario da maquina do usúario.
	_cLocal := GetTempPath()
	//Recebe a extenção do arquivo (.pdf, .jpg, .png)
	_cExten := SA1->A1_EXTEN
	//Recebe a cadeia de caracteres do arquivo
	_cAbrir := SA1->A1_MEMO
	//Recebe o Local onde o arquivo sera aberto + Nome do arqivo + extenção do arquivo
	_cDestino := _cLocal + _Nome +_cExten
	//decodifica o arquivo com a cadeia de caracteres e transforma seu formato original
	_cDeco := Decode64(_cAbrir, @_cDestino, .F.)
	conout("Arquivo aberto...")
	//Executa um arquivo salvo no Windows
	ShellExecute( "open", @_cDestino, "", "", 3 )

	RestArea(_aSA1)
Return


