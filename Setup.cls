/// FHIRリポジトリ（FHIRSERVER）用ネームスペース作成／初期設定用クラス
/// （GUIの提供あり　開発環境テンプレートでは自動生成のため以下クラスを用意） 
Class ISJ.Setup
{

/// FHIR R4リポジトリを作成するため、ネームスペースとFHIR用構成（RESTのベースURLなど）を作成
/// アプリケーションサンプル（Interoperabilityメニューのプロダクション）をインポート
ClassMethod setUpFHIR(ns As %String = "r4fhirnamespace") As %Status
{
   
    #dim ex As %Exception.AbstractException
    set status=$$$OK

    try {

        // ネームスペース作成（ユーティリティがあるHSLIBに移動してユーティリティ実行）
        set $namespace = "HSLIB"
        // サンプルインポートのためのベースディレクトリのパスを設定
        set baseDir = "/opt/app/"
        // ネームスペース名：R4FHIRNamespace　を作成
        //set status = ##class(HS.HC.Util.Installer).InstallFoundation(ns)
        set status=##class(HS.Util.Installer.Foundation).Install(ns)
        $$$ThrowOnError(status)

        // 作成したR4FHIRNamespaceに移動し、FHIRリポジトリ作成＋サンプルデータロード
        set $namespace = ns
        // FHIR対応用ネームスペース作成のために必要なインストールを実施
        do ##class(HS.FHIRServer.Installer).InstallNamespace()

        // FHIRリポジトリ用RESTのベースパス作成準備
        set tFHIRApp = "/csp/healthshare/"_ns_"/fhir/r4"
        set tStrategyClass = "HS.FHIRServer.Storage.Json.InteractionsStrategy"
        set tMetadataConfigKey = "HL7v40"

        // FHIRサーバ機能を作成したネームスペースにインストール
        do ##class(HS.FHIRServer.Installer).InstallInstance(tFHIRApp, tStrategyClass, tMetadataConfigKey,"",0)

        // FHIRアプリケーション用の構成
        set strategy = ##class(HS.FHIRServer.API.InteractionsStrategy).GetStrategyForEndpoint(tFHIRApp) 
        set configData = strategy.GetServiceConfigData() 
        set configData.DebugMode = 4   
        do strategy.SaveServiceConfigData(configData)

    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}


}