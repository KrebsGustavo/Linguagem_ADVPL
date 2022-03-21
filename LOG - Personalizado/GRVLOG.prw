#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"


    /************************************************************************************************\
    |************************************************************************************************|
    |*******************************================================= *******************************|
    |*******************************     User Function A2IMP()        *******************************|
    |*******************************     @author Gustavo Krebs        *******************************|
    |*******************************     @since 10/01/2021            *******************************|
    |*******************************          DESCRIÇÃO:              *******************************|
    |*******************************  Grava LOG.                      *******************************|
    |*******************************==================================*******************************|
    \************************************************************************************************/

    User Function FATZLOG(cRegistro)
    //Rotina personalizada, grava log de acordo com os registros da assiatura 

        //Recebe o ID do usuário Logado 
        Local _cCodUsr  := cUserID
        //Recebe o nome do Usuário  
        Local _cUsrName := FwNoAccent(Upper(cUserName))
        //Recebe os registros de acordo com o fonte que chama a função. 
        Local _cReg     := FwNoAccent(Upper(cRegistro))
        

        dbSelectArea("ZRL")
        dbSetOrder(1)

        If RecLock("ZRL", .T.)
            // Grava na tabela a filial logada 
            ZRL->ZRL_FILIAL := xFilial("ZRL")
            // Grava na tabela o ID do usuário 
            ZRL->ZRL_CODUSR := _cCodUsr
            // Grava na tabela a data que a rotina esta sendo chamada 
            ZRL->ZRL_DATA   := dDataBase
            // Grava na tabela a Hora que a rotina esta sendo chamada 
            ZRL->ZRL_HORA   := Time()
            // Grava o registro da operação que esta sendo chamada 
            ZRL->ZRL_REG    := _cReg
            // Grava o nome do Usuário 
            ZRL->ZRL_NOME   := _cUsrName
            MsUnLock()
        Else
            ConOut("Nao foi possivel gravar registro de LOG na ZRL")
        EndIf

    Return
