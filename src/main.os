﻿#Использовать "model"

Процедура ПриНачалеРаботыСистемы()
	
	ИспользоватьСтатическиеФайлы();
	ИспользоватьМаршруты("НастроитьМаршруты");

	МенеджерНастроек.Инициализировать();

КонецПроцедуры

Процедура НастроитьМаршруты(КоллекцияМаршрутов)

	КоллекцияМаршрутов.Добавить("ПоУмолчанию", "{controller=dashboard}/{action=Index}");

КонецПроцедуры
