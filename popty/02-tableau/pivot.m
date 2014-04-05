function Y = pivot(X, col, row)
    nonpivot_row = 2 + (3 - row);
    Y = X;
    Y(row, :) = Y(row, :) / Y(row, col);
    Y(nonpivot_row, :) = Y(nonpivot_row, :) - Y(row, :) * Y(nonpivot_row, col);
    Y(1, :) = Y(1, :) - Y(1, col) * Y(row, :);
end

