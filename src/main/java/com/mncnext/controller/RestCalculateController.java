package com.mncnext.controller;

import com.mncnext.domain.MoneyDTO;
import com.mncnext.service.MoneyService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/Cul")
public class RestCalculateController {

    private final MoneyService moneyService;

    public RestCalculateController(MoneyService moneyService) {
        this.moneyService = moneyService;
    }
    //계산 처리를 하는 메서드입니다 ajax로 부터 호출을 받습니다
    @RequestMapping("/Calculate")
    public String Calculate(MoneyDTO moneyDTO) {

        String result;

        //api의 오류에 대비한 조건문입니다
        if(moneyService.getExchangeRate(moneyDTO.getCurrency()).equals("통신오류")){

            result = "현재 서버상태가 오류입니다";

        }else {

            //MoneyDTO에 환율을 조회하여 set메서드를 실행시켜 데이터를 입력합니다
            moneyDTO.setExchangeRate(moneyService.getExchangeRate(moneyDTO.getCurrency()));
            result = (moneyService.Calculate(moneyDTO));

        }

        // 뷰단으로 계산한 결과를 리턴합니다
        return result;
    }
}
