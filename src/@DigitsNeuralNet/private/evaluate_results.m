function correct = evaluate_results(obj)
correct = 0;
for x = obj.test_data.'
   if (obj.evaluate(x{1}) == x{2})
       correct = correct + 1;
   end
end
end

