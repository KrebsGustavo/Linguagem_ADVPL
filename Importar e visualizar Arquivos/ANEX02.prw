#Include "Protheus.ch"
#include "totvs.ch"
#include 'fileio.ch'
     

    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function Anex02()       *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 14/12/2021            *******************************|
    |*******************************          DESCRI��O:              *******************************|
    |*******************************  Fun��o que abre uma janela para *******************************|
    |******************************* sele��o de um arquivo. verifica  *******************************|
    |******************************* se j� possu� um arquivo e chama  *******************************|
    |******************************* a fun��o IPORDOC() a mesma ira   *******************************|
    |******************************* guardar o arquivo no banco       *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  User Function ANEX02()

        // Recebe a fun��o GetArea()
        Local aSA1 := SA1->(GetArea())
        // Recebe a fun��o cGetFile 
        Private _cDiret

        //Condi��o que fara a verifica��o se ja possu� algum arquivo salvo.
        //Se for vazio pula e segue o processo normalmente 
        IF !EMPTY(SA1->A1_EXTEN)
            //Se for diferente de vazio, � porque j� possu� um arquivo ent�o apresentara o seguinte aviso.
            nOpc := Aviso( "ATEN��O", 'Se continuar com o processo o arquivo ser� substituido!', { "Continuar", "Cancelar" },2)
            //Se clicar em cancelar restaura o ambiente e Return 
                If nOpc == 2
                   RestArea(aSA1)
	               Return
                  //Se clicar em continuar segue o pocesso normalmente, porem o arquivo que existe salvo em banco ser� sustituido.
                ElseIf nOpc == 1
                  ConOut( "Arquivo sera substituido")
                  MsgInfo("Somente arquivos em (PDF), (JPG) e (PNG) s�o Aceito!", "ATEN��O")
                Endif
        Else 
            MsgInfo("Somente arquivos em (PDF), (JPG) e (PNG) s�o Aceito!", "ATEN��O")
        Endif
        
        //Fun��o que abre uma janela para sele��o de um arquivo.
		_cDiret := cGetFile('Arquito PDF|*.pdf| Arquivo PNG|*.png|Arquivo JPG|*.jpg',;                         
					        'Selecao de Arquivos',;                                                            
						    0,;                                                                              
					    	GetTempPath(),;                                                    
						    .F.,;                                                                           
			      		    nOR( GETF_LOCALHARD,  GETF_NETWORKDRIVE, ) ,;                                   
					    	.T.)                                              

        // Janela de carregamento, chamada da fun��o IPORDOC. 
        fwMsgRun(,{|oSay| IPORDOC(oSay) }, "Importa��o", "Iportando o Contrato...")

     RestArea(aSA1)
  Return 


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************   Static Function IPORDOC(oSay)  *******************************|
    |*******************************   @author Gustavo Krebs          *******************************|
    |*******************************   @since 18/01/2022              *******************************|
    |*******************************          DESCRI��O:              *******************************|
    |*******************************  Fun��o que importa o arquivo    *******************************|
    |******************************* Transformando string codificada  *******************************|
    |******************************* segundo o padr�o BASE64          *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

  Static Function IPORDOC(oSay)  

        //Recebe toda fun��o fopen
        Local _nNum         

        //Recebe string codificada segundo o padr�o BASE64
        Local _cString  := ""  

        //Receber o nome da exten��o do Arquivo (.pdf, .png, .jpg)
        Local _cExten   := ""            

        //Abre um arquivo bin�rio (__cDiret onde est� o diret�rio do arquivo, FO_READWRITE Aberto para leitura e grava��o, FO_SHARED Acesso compartilhado. Permite a leitura e grava��o por outros processos ao arquivo.)
        _nNum := fopen(_cDiret , FO_READWRITE + FO_SHARED)
        // Se o arquivo aberto for igual a -1 ent�o uma mensagem de erro sera apresentada
        If _nNum == -1
           MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
        // Caso o arquivo for diferente de -1 segue o procesamento... 
        Else
           conout('Arquivo aberto com sucesso.')
        // Divide um caminho de disco completo em todas as suas subpartes (drive, diret�rio, nome e extens�o).
           SplitPath( _cDiret, , , ,  @_cExten )
        // Posiciona o ponteiro do arquivo para as pr�ximas opera��es de leitura ou grava��o.(0 = Ajusta a partir do in�cio do arquivo. 2 = Ajuste a partir do final do arquivo.)
           _nTam := FSEEK(_nNum, 0,2)
        //  Posiciono o ponteiro 0 = Ajusta a partir do in�cio do arquivo.
	       FSEEK(_nNum, 0)
        // L� caracteres de um arquivo bin�rio para uma vari�vel de buffer.
	       FRead(_nNum, @_cString, _nTam)
        // Permite a inslus�o ou altera��o de um registro no alias informado.
           RecLock("SA1", .F.)
        // ZRG_EXTENC recebe o nome da exten��o do arquivo 	
           SA1->A1_EXTEN:=_cExten
        // ZRG_MINUTA recebe o arquivo codificado 
           SA1->A1_MEMO := Encode64(_cString)
        //Libera o travamento 
           SA1->(MsUnLock())
           conout("Arquivo salvo")
        //fecha um arquivo bin�rio aberto
           fclose(_nNum)     
        Endif

  Return
