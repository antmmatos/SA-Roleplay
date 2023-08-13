function StartPayCheck()
    CreateThread(function()
        while true do
            Wait(60000 * 30)
            for _, xPlayer in pairs(ESX.Players) do
                local jobLabel = xPlayer.job.label
                local job = xPlayer.job.grade_name
                local salary = xPlayer.job.grade_salary

                if salary > 0 then
                    if job == 'unemployed' then -- unemployed
                        xPlayer.addAccountMoney('bank', salary, "Fundo de desemprego")
                        -- Log and notification for welfare checks
                    else
                        TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
                            if society ~= nil then                  -- verified society
                                TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                                    if account.money >= salary then -- does the society money to pay its employees?
                                        xPlayer.addAccountMoney('bank', salary, "Paycheck")
                                        account.removeMoney(salary)
                                        -- Log and notification for paychecks
                                    else
                                        -- Log and notification: no balance
                                    end
                                end)
                            else -- not a society
                                xPlayer.addAccountMoney('bank', salary, "Salário")
                                -- Log and notification for paychecks
                            end
                        end)
                    end
                end
            end
        end
    end)
end
