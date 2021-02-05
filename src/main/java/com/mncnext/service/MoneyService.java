package com.mncnext.service;


import com.mncnext.domain.MoneyDTO;
import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;


@Service
public class MoneyService {

    //api로 부터 정보를 얻어 환율을 조회하는 메서드입니다
    public String getExchangeRate(String currency) {

        try {
            // 해당api에서 조회시 필요한코드를 currency로 보냅니다
            // REST API URL
            URL url = new URL("https://earthquake.kr:23490/query/" + currency);

            // REST API URL 커넥션 연결합니다
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            // StringBuilder 객체 생성후
            StringBuilder stringBuilder = new StringBuilder();

            // 통신 성공일 경우 내용을 한줄씩 읽어 StringBuilder 에 추가후 리턴합니다
            if(conn.getResponseCode() == HttpURLConnection.HTTP_OK) {

                BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
                stringBuilder.append(br.readLine());
                // 해당 api의 환율주소가 34글자 이후부터 나와 글자를 잘라준후 그뒤 ,로 필요없는 부분을 제거하여서 환율정보를 구합니다
                String exchangeRate[] = stringBuilder.toString().substring(34).split(",");
                //위 코드를 실행시 배열의 첫번째가 원하는 환율정보이기때문에 배열의 0번째를 리턴합니다
                return exchangeRate[0];
            }

        }

        catch(Exception e) {
            e.printStackTrace();
            return "통신오류";
        }

        return "통신오류";
    }

    public String Calculate(MoneyDTO moneyDTO) {

//        double나 float를 사용시 소숫점계산이 부정확하고 값이 커질경우 범위를 벗어날수있기때문에 BigDecimal를 사용하였습니다
        BigDecimal inputMoney = new BigDecimal(moneyDTO.getInputMoney());

        BigDecimal exchangeRate = new BigDecimal(moneyDTO.getExchangeRate());
//      입력한 값과 환율을 곱한후 리턴합니다
        return inputMoney.multiply(exchangeRate).toString();
    }
}