#Include "Protheus.ch"
#include "totvs.ch"
#include 'fileio.ch'
     

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function Anex02()       *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que abre uma janela para *******************************|
    |******************************* seleção de um arquivo. verifica  *******************************|
    |******************************* se já possuí um arquivo e chama  *******************************|
    |******************************* a função IPORDOC() a mesma ira   *******************************|
    |******************************* guardar o arquivo no banco       *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  User Function ANEX02()

        // Recebe a função GetArea()
        Local aSA1 := SA1->(GetArea())
        // Recebe a função cGetFile 
        Private _cDiret

        //Condição que fara a verificação se ja possuí algum arquivo salvo.
        //Se for vazio pula e segue o processo normalmente 
        IF !EMPTY(SA1->A1_EXTEN)
            //Se for diferente de vazio, é porque já possuí um arquivo então apresentara o seguinte aviso.
            nOpc := Aviso( "ATENÇÃO", 'Se continuar com o processo o arquivo será substituido!', { "Continuar", "Cancelar" },2)
            //Se clicar em cancelar restaura o ambiente e Return 
                If nOpc == 2
                   RestArea(aSA1)
	               Return
                  //Se clicar em continuar segue o pocesso normalmente, porem o arquivo que existe salvo em banco será sustituido.
                ElseIf nOpc == 1
                  ConOut( "Arquivo sera substituido")
                  MsgInfo("Somente arquivos em (PDF), (JPG) e (PNG) são Aceito!", "ATENÇÃO")
                Endif
        Else 
            MsgInfo("Somente arquivos em (PDF), (JPG) e (PNG) são Aceito!", "ATENÇÃO")
        Endif
        
        //Função que abre uma janela para seleção de um arquivo.
		_cDiret := cGetFile('Arquito PDF|*.pdf| Arquivo PNG|*.png|Arquivo JPG|*.jpg',;                         
					        'Selecao de Arquivos',;                                                            
						    0,;                                                                              
					    	GetTempPath(),;                                                    
						    .F.,;                                                                           
			      		    nOR( GETF_LOCALHARD,  GETF_NETWORKDRIVE, ) ,;                                   
					    	.T.)                                              

        // Janela de carregamento, chamada da função IPORDOC. 
        fwMsgRun(,{|oSay| IPORDOC(oSay) }, "Importação", "Iportando o Contrato...")

     RestArea(aSA1)
  Return 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function IPORDOC(oSay)  *******************************|
    |*******************************   @author Gustavo Krebs          *******************************|
    |*******************************   @since 18/01/2022              *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Função que importa o arquivo    *******************************|
    |******************************* Transformando string codificada  *******************************|
    |******************************* segundo o padrão BASE64          *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  Static Function IPORDOC(oSay)  

        //Recebe toda função fopen
        Local _nNum         

        //Recebe string codificada segundo o padrão BASE64
        Local _cString  := ""  

        //Receber o nome da extenção do Arquivo (.pdf, .png, .jpg)
        Local _cExten   := ""            

        //Abre um arquivo binário (__cDiret onde está o diretório do arquivo, FO_READWRITE Aberto para leitura e gravação, FO_SHARED Acesso compartilhado. Permite a leitura e gravação por outros processos ao arquivo.)
        _nNum := fopen(_cDiret , FO_READWRITE + FO_SHARED)
        // Se o arquivo aberto for igual a -1 então uma mensagem de erro sera apresentada
        If _nNum == -1
           MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
        // Caso o arquivo for diferente de -1 segue o procesamento... 
        Else
           conout('Arquivo aberto com sucesso.')
        // Divide um caminho de disco completo em todas as suas subpartes (drive, diretório, nome e extensão).
           SplitPath( _cDiret, , , ,  @_cExten )
        // Posiciona o ponteiro do arquivo para as próximas operações de leitura ou gravação.(0 = Ajusta a partir do início do arquivo. 2 = Ajuste a partir do final do arquivo.)
           _nTam := FSEEK(_nNum, 0,2)
        //  Posiciono o ponteiro 0 = Ajusta a partir do início do arquivo.
	       FSEEK(_nNum, 0)
        // Lê caracteres de um arquivo binário para uma variável de buffer.
	       FRead(_nNum, @_cString, _nTam)
        // Permite a inslusão ou alteração de um registro no alias informado.
           RecLock("SA1", .F.)
        // ZRG_EXTENC recebe o nome da extenção do arquivo 	
           SA1->A1_EXTEN:=_cExten
        // ZRG_MINUTA recebe o arquivo codificado 
           SA1->A1_MEMO := Encode64(_cString)
        //Libera o travamento 
           SA1->(MsUnLock())
           conout("Arquivo salvo")
        //fecha um arquivo binário aberto
           fclose(_nNum)     
        Endif

  Return
