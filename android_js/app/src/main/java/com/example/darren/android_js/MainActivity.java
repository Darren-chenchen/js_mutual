package com.example.darren.android_js;

import android.annotation.SuppressLint;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.Toast;

import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    WebView mWebView;
    Button btn;

    @SuppressLint("JavascriptInterface")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        mWebView = (WebView) findViewById(R.id.webview);
        btn = (Button) findViewById(R.id.btn);

        mWebView.setWebChromeClient(new WebChromeClient());
        mWebView.getSettings().setJavaScriptEnabled(true);
        WebSettings settings = mWebView.getSettings();
        settings.setDomStorageEnabled(true);
        settings.setJavaScriptEnabled(true);
        mWebView.loadUrl("file:///android_asset/h5/index.html");
        mWebView.addJavascriptInterface(this, "phone");

        btn.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mWebView.evaluateJavascript("javascript:showAlert('呵呵呵呵')", new ValueCallback<String>() {
                            @Override
                            public void onReceiveValue(String s) {
                            }
                        });
                    }
                });
            }
        });
    }

    @JavascriptInterface
    public String getPhoneInfo() {
        String brand = " 品牌 : " + android.os.Build.BRAND;
        String systemVersion = " Android 版本 : " + android.os.Build.VERSION.RELEASE;
        String systemName = " 型号 : " + android.os.Build.MODEL;
        return systemVersion + systemName + brand;
    }
    @JavascriptInterface
    public String getJson() {
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("baseUrl", "http://baidu.com");
        map.put("id", "测试id");
        Gson gson = new Gson();
        String result = gson.toJson(map);
        return result;
    }
}
