public with sharing class CalculateSimpleInterest 
{
    public static Decimal calculate(Decimal amount,Decimal rate,Integer timeYear)
    {
        return amount+(amount*rate*timeYear)/100;
    }
}