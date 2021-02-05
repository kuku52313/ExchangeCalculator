package com.mncnext.domain;

import lombok.Data;

@Data
public class MoneyDTO {
//계산의 정확도를 위해 BigDecimal를 사용예정이라 String로 선언하였습니다
    private String inputMoney;
    private String exchangeRate;
    private String Currency;


}
