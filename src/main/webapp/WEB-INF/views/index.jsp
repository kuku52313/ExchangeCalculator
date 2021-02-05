<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<html>
<head>
    <script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
    <title>환율 계산기</title>
    <style>
        .box {
            position:absolute;
            top:50%; left:50%;
            transform: translate(-50%, -50%);
        }
        .formText {
            font-size: 17px;
            box-sizing: border-box;
            width: 60%;
            height: 34px;
            color: #333333;
            text-align: left;
            border: 1px solid #bab5b5;
            border-radius: 4px;
            background: white;
            outline: none;
            margin-bottom: 20px;
            margin-right: 7px;
            display: inline-block;
            float: left;
            text-overflow: ellipsis;
        }
        .formCurrency {
            font-size: 17px;
            box-sizing: border-box;
            width: 35%;
            height: 34px;
            color: #333333;
            text-align: left;
            border: 1px solid #bab5b5;
            border-radius: 4px;
            background: white;
            outline: none;
            margin-bottom: 20px;
            margin-right: 7px;
            display: inline-block;
            float: left;
            text-overflow: ellipsis;
        }

        .insertBtn {
            display:inline-block;
            padding:7px 18px;
            background-color:  #bab5b5;
            font-size:17px;
            border:none;
            border-radius:5px;
            color: black;
            cursor:pointer;
            float: right;
            left: 580px;
            top: 50px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
<br>

<div class="box">
<%--    현재 환율을 구해서 계산하는 계산기입니다--%>
<%--    rest api는 https://earthquake.kr:23490/query/ 를 이용하였습니다--%>
<div>
    <h3 STYLE="text-align: center">현재환율 계산기</h3>
<%-- min값으로 음수값은 입력을 방지하였습니다   --%>
    <input type="number" class="formText" id="inputMoney" min="0">
    <select id="inCurrency"  class="formCurrency">
        <option value="">화폐 선택</option>
        <option value="한국">한국 / KRW</option>
        <option value="미국">미국 / USD</option>
        <option value="중국">중국 / CNY</option>
        <option value="유럽">유럽 / EUR</option>
        <option value="일본">일본 / JPY</option>
    </select>
</div>
    <div>
<%-- 임의로 값 변경을 막기위해 readonly로 선언하였습니다       --%>
    <input type="number" class="formText" id="resultMoney" readonly style="background: rgba(0,0,0,0.05)">
<%-- 위의 셀렉트박스의 값에따라 아래의 코드가 결정됩니다     --%>
    <select id="resultCurrency" class="formCurrency">

    </select>
    </div>
    <input type="button" class="insertBtn" onclick="CalculateFn()" value="계산하기">

</div>
</body>
</html>


<script type="text/javascript">

    function CalculateFn() {
        // null체크를 하기위해 값을 받아옵니다
        var checkCurrency = $('#resultCurrency').val();
        var checkInMoney= $('#inputMoney').val();
        //널 체크후 계산을 시작합니다
        if (checkCurrency == null){
            alert("환율조회할 화폐를 선택하여주세요")
        }else if((checkInMoney == null || checkInMoney == 0)){
            alert("숫자를 입력하여주세요")
        }else{
            // api에서 요구하는 조회방식에 맞춰 데이터를 전송합니다 입력값과 해당 거래의 환율을 구하는 코드를 api에 요청합니다
            var sendData = {
                // 사용자가 입력한 값입니다
                inputMoney: $("#inputMoney").val(),

                // 조회하고자 하는 환율의 코드부분입니다 아래 셀렉트박스 관련 js에서 코드를 결정합니다
                Currency: $("#resultCurrency").val(),
            };
            //ajax를 사용한 이유는 새로고침을 방지하기 하기위해 사용하였습니다 한번조회시 마다 새로고침될필요는 없다 생각하여 비동기통신은 ajax를 사용하였습니다
            $.ajax({
                url: "/Cul/Calculate",
                type: "Get",
                data: sendData,
                success: function (data) {
                    // 혹시나 모를 api가 오류일때를 대비해 서버가 오류일시 출력되는 값입니다
                    if(data === "현재 서버상태가 오류입니다"){
                        alert(data);
                    }else{
                        // 정상적으로 조회시 서버단에서 계산된후의 정보를 넣습니다
                        $("#resultMoney").val(data)
                    }
                },
                error: function () {
                    alert("Error. 관리자에게 문의하십시오.");
                },
            });
        }
    }


    //inCurrency셀렉트박스의 값에따라 resultCurrency의 셀렉트박스의 값을 변화시켜 api에 보낼 코드를 결정하는 로직입니다
    $(function() {

        $('#inCurrency').change(function() {

            var KRW = ["호주 / AUD", "브라질 / BRL","캐나다 / CAD","스위스 / CHF","중국 / CNY","유럽 / EUR","영국 / GBP","홍콩 / HKD","인도 / INR","일본 / JPY","멕시코 / MXN","러시아 / RUB","태국 / THB","대만 / TWD","미국 / USD","베트남 / VND"];
            var KRWCurrency = ["KRWAUD", "KRWBRL","KRWCAD","KRWCHF","KRWCNY","KRWEUR","KRWGBP","KRWHKD","KRWINR","KRWJPY","KRWMXN","KRWRUB","KRWTHB","KRWTWD","KRWUSD","KRWVND"];

            var USD = ["호주 / AUD", "브라질 / BRL","캐나다 / CAD","스위스 / CHF","중국 / CNY","유럽 / EUR","영국 / GBP","홍콩 / HKD","인도 / INR","일본 / JPY","한국 / KRW","멕시코 / MXN","러시아 / RUB","태국 / THB","대만 / TWD","베트남 / VND"];
            var USDCurrency = ["USDAUD","USDBRL","USDCAD","USDCHF","USDCNY","USDEUR","USDGBP","USDHKD","USDINR","USDJPY","USDKRW","USDMXN","USDRUB","USDTHB","USDTWD","USDVND"];

            var CNY = ["호주 / AUD", "브라질 / BRL","캐나다 / CAD","스위스 / CHF","유럽 / EUR","영국 / GBP","홍콩 / HKD","인도 / INR","일본 / JPY","한국 / KRW","멕시코 / MXN","러시아 / RUB","태국 / THB","대만 / TWD","미국 / USD","베트남 / VND"];
            var CNYCurrency = ["CNYAUD","CNYBRL","CNYCAD","CNYCHF","CNYEUR","CNYGBP","CNYHKD","CNYINR","CNYJPY","CNYKRW","CNYMXN","CNYRUB","CNYTHB","CNYTWD","CNYUSD","CNYVND"];

            var EUR = ["호주 / AUD", "브라질 / BRL","캐나다 / CAD","스위스 / CHF","중국 / CNY","영국 / GBP","홍콩 / HKD","인도 / INR","일본 / JPY","한국 / KRW","멕시코 / MXN","러시아 / RUB","태국 / THB","대만 / TWD","미국 / USD","베트남 / VND"];
            var EURCurrency = ["EURAUD","EURBRL","EURCAD","EURCHF","EURCNY","EURGBP","EURHKD","EURINR","EURJPY","EURKRW","EURMXN","EURRUB","EURTHB","EURTWD","EURUSD","EURVND"];

            var JPY = ["호주 / AUD", "브라질 / BRL","캐나다 / CAD","스위스 / CHF","중국 / CNY","유럽 / EUR","영국 / GBP","홍콩 / HKD","인도 / INR","한국 / KRW","멕시코 / MXN","러시아 / RUB","태국 / THB","대만 / TWD","미국 / USD","베트남 / VND"];
            var JPYCurrency = ["JPYAUD","JPYBRL","JPYCAD","JPYCHF","JPYCNY","JPYEUR","JPYGBP","JPYHKD","JPYINR","JPYKRW","JPYMXN","JPYRUB","JPYTHB","JPYTWD","JPYUSD","JPYVND"];

            var changeItem;
            var changeCurrency;

            //셀렉트박스의 값을 조회후 배열을 맞춰서 끼웁니다
            if (this.value == "한국") {
                changeItem = KRW;
                changeCurrency = KRWCurrency;
            } else if (this.value == "미국") {
                changeItem = USD;
                changeCurrency = USDCurrency;
            }else if (this.value == "중국") {
                changeItem = CNY;
                changeCurrency = CNYCurrency;
            }else if (this.value == "유럽") {
                changeItem = EUR;
                changeCurrency = EURCurrency;
            }else if (this.value == "일본") {
                changeItem = JPY;
                changeCurrency = JPYCurrency;
            }
            //셀렉트박스에 옵션을 주기전 셀렉트박스내의 옵션을 비웁니다
            $('#resultCurrency').empty();

            // 배열의 크기만큼 반복하는 반복문입니다 위에서 나온 배열의 값을 옵션의 이름과 value에 저장하여 옵션을 동적으로 생성합니다
            for (var count = 0; count < changeItem.length; count++) {

                var option = $("<option value= "+ changeCurrency[count] + ">" + changeItem[count] + "</option>");

                $('#resultCurrency').append(option);

            }

        });

    });
</script>
