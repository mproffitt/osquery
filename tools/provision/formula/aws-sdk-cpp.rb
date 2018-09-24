require File.expand_path("../Abstract/abstract-osquery-formula", __FILE__)

class AwsSdkCpp < AbstractOsqueryFormula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  license "Apache-2.0"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.6.15.tar.gz"
  sha256 "a0511813d43628ee07552c2d79868ef59ae3f1fd0428fbdc5412ad8ecda27891"
  revision 1

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    args = osquery_cmake_args
    args << "-DSTATIC_LINKING=1"
    args << "-DNO_HTTP_CLIENT=1"
    args << "-DMINIMIZE_SIZE=ON"
    args << "-DBUILD_SHARED_LIBS=OFF"
    args << "-DENABLE_TESTING=OFF"
    args << "-DAUTORUN_UNIT_TESTS=OFF"

    args << "-DBUILD_ONLY=ec2;firehose;kinesis;sts"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Move lib64/* to lib/ on Linuxbrew
    lib64 = Pathname.new "#{lib}64"
    if lib64.directory?
      mkdir_p lib
      system "mv #{lib64}/* #{lib}/"
      rmdir lib64
    end
  end
end
