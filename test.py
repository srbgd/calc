import sys
import random
import subprocess


def get_exp(d = 0):
	n = random.randint(0, 8)
	if d > 5:
		n = 10
	d += 1
	if n == 0 or n == 1:
		return get_exp(d) + '+' + get_exp(d)
	elif n == 2 or n == 3:
		return get_exp(d) + '-' + get_exp(d)
	elif n == 4 or n == 5:
		return get_exp(d) + '*' + get_exp(d)
	elif n == 6:
		return '(' + get_exp(d) + ')'
	else:
		return ('(-{})' if n % 4 == 0 else '{}').format(str(random.randint(0, 20)))


def test_case():
	s = get_exp()
	while abs(eval(s)) > 1000000:
		s = get_exp()
	result = int(subprocess.run(['./calc'], input=str.encode(s), stdout=subprocess.PIPE).stdout)
	return result == eval(s), s


def test(n):
	count = 0
	for _ in range(n):
		result = test_case()
		if result[0]:
			count += 1
		else:
			print(result[1])
	return count


def main():
	n = int(sys.argv[1])
	count = test(n)
	print('Passed {}/{} tests'.format(count, n))


if __name__ == '__main__':
	main()
