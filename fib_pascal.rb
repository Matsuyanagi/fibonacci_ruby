#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#-----------------------------------------------------------------------------
#	フィボナッチ数列 一般項  1/√5 ( ( (1+√5)/2 )^n - ( ( 1-√5)/2)^n ) を変形
#		
#		
#		
#	nCr を単純に階乗で実装すると非常に大きくなりすぎて実用に耐えない。
#		足し算ループに対するメリットとしては各項 C√5^(n) を並列計算できる
#
# fib( 10000 ) で E580 で97秒
#        user     system      total        real
#  97.031000   0.359000  97.390000 ( 97.403510)
#	
#	2020-02-16
#-----------------------------------------------------------------------------
require 'fileutils'
require 'date'
require 'time'
require 'benchmark'

Encoding.default_external="utf-8"
#-----------------------------------------------------------------------------
#	
#-----------------------------------------------------------------------------
settings = {
	
}



#-----------------------------------------------------------------------------
# 階乗
#-----------------------------------------------------------------------------
def factorial( number )
  (1..number).inject(1,:*)
end

#-----------------------------------------------------------------------------
# 組み合わせ数  n の中から r を選ぶ組み合わせ
#	階乗を使うと数値が大きくなりすぎる
#	漸化式なら nCr = (n-1)C()
#-----------------------------------------------------------------------------
def combination( n, r )
	factorial( n ) / ( factorial( r ) * factorial( n - r ) )
end

# https://www.mk-mode.com/blog/2020/02/05/ruby-binomial-coefficients/#
# 二項係数の計算(4)
#   計算式: (n r) = Π(n - i + 1) / i  (i = 1, ..., r)
#
# @param  n: n の値
# @param  r: r の値
# @return  : 二項係数
def binom_4(n, r)
	return 1 if r == 0 || r == n
	return (1..r).inject(1) { |s, i| s * (n - i + 1) / i }
	rescue => e
	raise
end


#-----------------------------------------------------------------------------
# √5 ^ n = 5 ** (n/2)
#-----------------------------------------------------------------------------
def int_root5_exp( n )
	raise if n.odd?
	5 ** (n/2)
end

#-----------------------------------------------------------------------------
# fib
#-----------------------------------------------------------------------------
def fib( target )
	sum = 0
	(target+1).times do |n|
		if n.odd?
			# puts "-"
			# puts "n : #{n}"
			# puts "combination( target, n ) : #{combination( target, n )}"
			# puts "int_root5_exp( n-1 ) : #{int_root5_exp( n-1 )}"
			# 奇数項だけ。偶数項は引き算で消える
			# sum += 2 * combination( target, n ) * int_root5_exp( n-1 )
			sum += 2 * binom_4( target, n ) * int_root5_exp( n-1 )

		end

	end
	# puts "sum : #{sum}"
	sum >> target
end

#-----------------------------------------------------------------------------
#	
#-----------------------------------------------------------------------------
def main( settings )
	puts( "---- factorial" )
	pp factorial( 0 )
	pp factorial( 1 )
	pp factorial( 2 )
	pp factorial( 3 )
	pp factorial( 4 )
	pp factorial( 5 )
	puts( "----" )
	
	puts( "---- combination" )
	pp combination(  5, 0 )
	pp combination(  5, 1 )
	pp combination(  5, 2 )
	pp combination(  5, 3 )
	pp combination(  5, 4 )
	pp combination(  5, 5 )
	puts( "----" )
	puts( "---- fib" )

	10.times do |n|
		puts( %Q!#{n+1} : #{fib( n+1 )}! )
	end

	
	n = 10000
	result = nil
	Benchmark.bm do |bm|
		bm.report do
			result = fib( n )
		end
	end
	puts( %Q!#{n} : #{result}! )
	

=begin
 	puts( %Q!#{1} : #{fib( 1 )}! )
	puts( %Q!#{2} : #{fib( 2 )}! )
	puts( %Q!#{3} : #{fib( 3 )}! )
	puts( %Q!#{4} : #{fib( 4 )}! )
	puts( %Q!#{5} : #{fib( 5 )}! )
=end	
	
end

main( settings )