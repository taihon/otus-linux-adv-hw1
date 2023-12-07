# Terraform basics with nginx

### Суть проекта:
Базовая практика разворота инфраструктуры в Яндекс.Облаке при помощи связки Terraform и Ansible

### Как развернуть

Для разворота потребуется:
1. Настроить среду согласно [документации Яндекс](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart):

    1. Создать service account, присвоить ему права editor
    2. Создать ключ, сохранив его в файл
    3. Создать профиль
    4. Установить параметр service-account-key равным имени файла ключа
    5. Задать переменные окружения YC_TOKEN, YC_CLOUD_ID,
    YC_FOLDER_ID
    6. (опционально) добавить эти переменные в .bashrc
2. Запустить команду 
```
terraform plan
```
3. Запустить команду, если согласны с предложенным планом:
```
terraform apply
```