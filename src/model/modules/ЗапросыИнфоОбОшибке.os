Функция ПолучитьСписок() Экспорт

	ХранилищеДанных = МенеджерНастроек.ХранилищеДанных();

	Возврат ХранилищеДанных.ПолучитьЗапросыИнфоОбОшибках();

КонецФункции

Процедура Записать(ЗапросИнфоОбОшибке) Экспорт

	ХранилищеДанных = МенеджерНастроек.ХранилищеДанных();

	ХранилищеДанных.ЗаписатьЗапросИнфоОбОшибке(ЗапросИнфоОбОшибке);

КонецПроцедуры
