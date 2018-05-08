# ソケット通信(TCP/IP(つまりインターネット))の通信をする
- 各言語で、server.{l,c,py} と client.{l,c,py} を作る感じ。

---
# サンプル
- サーバ側
    - EusLisp  
    (load "server.l")  
    (start-server 'sample-func)  
    (stop-server)  
- クライアント側
    - EusLisp  
    (load "client.l")  
    (setq s (connect-host :host "192.168.4.123" :port 9000))  
    (print #f(1 2 3) s)  
    (print "ikuo" s)  
    (format s "My name is Ikuo.~%")  
    (print :end s)  

---
# サーバ用の関数

## サーバ起動

- 関数名は、**(start-server) または start_server() または startServer()**
- 引数は、ホスト名(IP)、ポート番号、接続されたら実行する関数
- ソケットを作って、接続を待つスレッドを起動したら、関数は戻ってくる。
- 接続されたら、別スレッドを起動して、そのスレッドで指定した関数を実行
- その関数の実行が終了したら、接続を切って、スレッドは終了。

### 接続された実行する関数
- 仕様
   - ユーザが書く
   - 引数は、ストリーム
   - 戻り値は無し。
   - 終了すると、その接続は切断される。

## サーバ終了

- 関数名は、**(stop-server) または stop_server() または stopServer()**
- 接続スレッドと、接続待ち受けスレッドを終了して、ソケットを閉じる。

---
# クライアント用の関数

## サーバに接続

- 関数名は、**(connect-host) または connect_host() または connectHost()**
- 引数は、サーバのホスト名・ポート番号
- 戻り値は、ストリームオブジェクト（Cなら(FILE*)fp）

