#!/usr/bin/ruby
require 'set'

class Ma
    attr_accessor :tehai,:co
    def initialize()
        #@tehai = {}
        @tehai = {1=>1,2=>0,3=>1,4=>0,5=>3,6=>3,7=>3,8=>0,9=>2}
        @co = 0
    end
    def count
        ret = 0
        @tehai.each {|k,v| ret+=v}
        return ret
    end
    def maketehai()
        while count < 13
            inp = gets
            inp = inp.chomp.to_i
            if Set.new((1..9).to_a).member?(inp)
                @tehai[inp] = 0 unless @tehai[inp]
                @tehai[inp] += 1
                p @tehai
            end
        end
    end
    def machi(r1,r2,r0)
        if r1 > r2
            tmp = r1
            r1 = r2
            r2 = tmp
        end
        if r1 == r2
            return 'shabo',[r1,r0]
        #penchan
        elsif r1+r2 == 3 
            return 'penchan',[3]
        elsif r1+r2 == 17
            return 'penchan',[7]
        #ryanmen
        elsif r2 - r1 == 1
            return 'ryanmen',[r1-1,r2+1] 
        #kanchan
        elsif r2 - r1 == 2
            return 'kanchan',[r1+1]
        else
            return false
        end
    end
    def atamaget()
        ret = []
        @tehai.each do |k,v|
            tehai = @tehai.dup
            next if v == 0
            if v == 1
                tehai[k] -= 1
                ret << [[k],tehai]
            else
                tehai[k] -= 2 
                ret << [[k,k],tehai]
            end
        end
        return ret
    end
    def converth2a(tehai)
        ret = []
        tehai.each do |k,v|
            ret += [k]*v
        end
        ret.sort!
        return ret
    end
    def hantei(nokori_a)
        @co += 1
        n = nokori_a.dup
        if n == []
            return true
        elsif n[0] == n[1] && n[1] == n[2]
            3.times do |i|
                n.delete_at(0);
            end
            return false unless hantei(n)
        elsif n[1] == n[0]+1 && n[2] == n[0]+1
            if n.include?(n[1]+1)
                n.delete_at(0);n.delete_at(0)
                return false unless n.index(n[0]+1)
                n.delete_at(n.index(n[0]+1))
                return false unless hantei(n)
            else
                return false
            end
        elsif n[0] == n[1] && n[2] == n[1]+1
            if n.include?(n[2]+1)
                n.delete_at(1);n.delete_at(1)
                return false unless n.index(n[0]+2)
                n.delete_at(n.index(n[0]+2))
                return false unless hantei(n)
            else
                return false
            end
        elsif n[1] == n[0]+1 && n[2] == n[0]+2
            3.times do |i|
                n.delete_at(0)
            end
            return false unless hantei(n)
        else
            return false
        end
        return true
    end
    def main()
        kouho = atamaget()
        machi_m = []
        kouho.each do |i|
            #atama=1
            if i[0].size == 1
                a = converth2a(i[1])
                if hantei(a)
                    ma = ['tanki',i[0]]
                    machi_m << "machi = #{ma}\n"
                end
                #7toi
                count = 0
                i[1].each{|k,v| count += 1 if v==2}
                machi_m << "machi = #{['tanki7',i[1].invert[1]]}\n" if count == 6
            #atama=2
            else
                10.times do |j|
                    a = converth2a(i[1])
                    if ma = machi(a[j*1],a[j*1+1],i[0][0])
                        a.delete_at(j*1);a.delete_at(j*1)
                        if hantei(a)
                            machi_m << "machi = #{ma}\n"
                        end
                    end
                end
            end
        end
        puts machi_m
    end
end
i = Ma.new
i.maketehai
i.main
puts i.co
