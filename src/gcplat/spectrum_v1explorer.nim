
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Spectrum Database
## version: v1explorer
## termsOfService: (not provided)
## license: (not provided)
## 
## API for spectrum-management functions.
## 
## http://developers.google.com/spectrum
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "spectrum"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpectrumPawsGetSpectrum_588709 = ref object of OpenApiRestCall_588441
proc url_SpectrumPawsGetSpectrum_588711(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsGetSpectrum_588710(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests information about the available spectrum for a device at a location. Requests from a fixed-mode device must include owner information so the device can be registered with the database.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588866: Call_SpectrumPawsGetSpectrum_588709; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests information about the available spectrum for a device at a location. Requests from a fixed-mode device must include owner information so the device can be registered with the database.
  ## 
  let valid = call_588866.validator(path, query, header, formData, body)
  let scheme = call_588866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588866.url(scheme.get, call_588866.host, call_588866.base,
                         call_588866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588866, url, valid)

proc call*(call_588937: Call_SpectrumPawsGetSpectrum_588709; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spectrumPawsGetSpectrum
  ## Requests information about the available spectrum for a device at a location. Requests from a fixed-mode device must include owner information so the device can be registered with the database.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588938 = newJObject()
  var body_588940 = newJObject()
  add(query_588938, "fields", newJString(fields))
  add(query_588938, "quotaUser", newJString(quotaUser))
  add(query_588938, "alt", newJString(alt))
  add(query_588938, "oauth_token", newJString(oauthToken))
  add(query_588938, "userIp", newJString(userIp))
  add(query_588938, "key", newJString(key))
  if body != nil:
    body_588940 = body
  add(query_588938, "prettyPrint", newJBool(prettyPrint))
  result = call_588937.call(nil, query_588938, nil, nil, body_588940)

var spectrumPawsGetSpectrum* = Call_SpectrumPawsGetSpectrum_588709(
    name: "spectrumPawsGetSpectrum", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getSpectrum",
    validator: validate_SpectrumPawsGetSpectrum_588710,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsGetSpectrum_588711,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsGetSpectrumBatch_588979 = ref object of OpenApiRestCall_588441
proc url_SpectrumPawsGetSpectrumBatch_588981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsGetSpectrumBatch_588980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Google Spectrum Database does not support batch requests, so this method always yields an UNIMPLEMENTED error.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588982 = query.getOrDefault("fields")
  valid_588982 = validateParameter(valid_588982, JString, required = false,
                                 default = nil)
  if valid_588982 != nil:
    section.add "fields", valid_588982
  var valid_588983 = query.getOrDefault("quotaUser")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "quotaUser", valid_588983
  var valid_588984 = query.getOrDefault("alt")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = newJString("json"))
  if valid_588984 != nil:
    section.add "alt", valid_588984
  var valid_588985 = query.getOrDefault("oauth_token")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = nil)
  if valid_588985 != nil:
    section.add "oauth_token", valid_588985
  var valid_588986 = query.getOrDefault("userIp")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "userIp", valid_588986
  var valid_588987 = query.getOrDefault("key")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "key", valid_588987
  var valid_588988 = query.getOrDefault("prettyPrint")
  valid_588988 = validateParameter(valid_588988, JBool, required = false,
                                 default = newJBool(true))
  if valid_588988 != nil:
    section.add "prettyPrint", valid_588988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_588990: Call_SpectrumPawsGetSpectrumBatch_588979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Google Spectrum Database does not support batch requests, so this method always yields an UNIMPLEMENTED error.
  ## 
  let valid = call_588990.validator(path, query, header, formData, body)
  let scheme = call_588990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588990.url(scheme.get, call_588990.host, call_588990.base,
                         call_588990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588990, url, valid)

proc call*(call_588991: Call_SpectrumPawsGetSpectrumBatch_588979;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## spectrumPawsGetSpectrumBatch
  ## The Google Spectrum Database does not support batch requests, so this method always yields an UNIMPLEMENTED error.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588992 = newJObject()
  var body_588993 = newJObject()
  add(query_588992, "fields", newJString(fields))
  add(query_588992, "quotaUser", newJString(quotaUser))
  add(query_588992, "alt", newJString(alt))
  add(query_588992, "oauth_token", newJString(oauthToken))
  add(query_588992, "userIp", newJString(userIp))
  add(query_588992, "key", newJString(key))
  if body != nil:
    body_588993 = body
  add(query_588992, "prettyPrint", newJBool(prettyPrint))
  result = call_588991.call(nil, query_588992, nil, nil, body_588993)

var spectrumPawsGetSpectrumBatch* = Call_SpectrumPawsGetSpectrumBatch_588979(
    name: "spectrumPawsGetSpectrumBatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getSpectrumBatch",
    validator: validate_SpectrumPawsGetSpectrumBatch_588980,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsGetSpectrumBatch_588981,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsInit_588994 = ref object of OpenApiRestCall_588441
proc url_SpectrumPawsInit_588996(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsInit_588995(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Initializes the connection between a white space device and the database.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("quotaUser")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "quotaUser", valid_588998
  var valid_588999 = query.getOrDefault("alt")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("json"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("userIp")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "userIp", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("prettyPrint")
  valid_589003 = validateParameter(valid_589003, JBool, required = false,
                                 default = newJBool(true))
  if valid_589003 != nil:
    section.add "prettyPrint", valid_589003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589005: Call_SpectrumPawsInit_588994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initializes the connection between a white space device and the database.
  ## 
  let valid = call_589005.validator(path, query, header, formData, body)
  let scheme = call_589005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589005.url(scheme.get, call_589005.host, call_589005.base,
                         call_589005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589005, url, valid)

proc call*(call_589006: Call_SpectrumPawsInit_588994; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spectrumPawsInit
  ## Initializes the connection between a white space device and the database.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589007 = newJObject()
  var body_589008 = newJObject()
  add(query_589007, "fields", newJString(fields))
  add(query_589007, "quotaUser", newJString(quotaUser))
  add(query_589007, "alt", newJString(alt))
  add(query_589007, "oauth_token", newJString(oauthToken))
  add(query_589007, "userIp", newJString(userIp))
  add(query_589007, "key", newJString(key))
  if body != nil:
    body_589008 = body
  add(query_589007, "prettyPrint", newJBool(prettyPrint))
  result = call_589006.call(nil, query_589007, nil, nil, body_589008)

var spectrumPawsInit* = Call_SpectrumPawsInit_588994(name: "spectrumPawsInit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/init",
    validator: validate_SpectrumPawsInit_588995,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsInit_588996,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsNotifySpectrumUse_589009 = ref object of OpenApiRestCall_588441
proc url_SpectrumPawsNotifySpectrumUse_589011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsNotifySpectrumUse_589010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Notifies the database that the device has selected certain frequency ranges for transmission. Only to be invoked when required by the regulator. The Google Spectrum Database does not operate in domains that require notification, so this always yields an UNIMPLEMENTED error.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589012 = query.getOrDefault("fields")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "fields", valid_589012
  var valid_589013 = query.getOrDefault("quotaUser")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "quotaUser", valid_589013
  var valid_589014 = query.getOrDefault("alt")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = newJString("json"))
  if valid_589014 != nil:
    section.add "alt", valid_589014
  var valid_589015 = query.getOrDefault("oauth_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "oauth_token", valid_589015
  var valid_589016 = query.getOrDefault("userIp")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "userIp", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("prettyPrint")
  valid_589018 = validateParameter(valid_589018, JBool, required = false,
                                 default = newJBool(true))
  if valid_589018 != nil:
    section.add "prettyPrint", valid_589018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589020: Call_SpectrumPawsNotifySpectrumUse_589009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Notifies the database that the device has selected certain frequency ranges for transmission. Only to be invoked when required by the regulator. The Google Spectrum Database does not operate in domains that require notification, so this always yields an UNIMPLEMENTED error.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_SpectrumPawsNotifySpectrumUse_589009;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## spectrumPawsNotifySpectrumUse
  ## Notifies the database that the device has selected certain frequency ranges for transmission. Only to be invoked when required by the regulator. The Google Spectrum Database does not operate in domains that require notification, so this always yields an UNIMPLEMENTED error.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589022 = newJObject()
  var body_589023 = newJObject()
  add(query_589022, "fields", newJString(fields))
  add(query_589022, "quotaUser", newJString(quotaUser))
  add(query_589022, "alt", newJString(alt))
  add(query_589022, "oauth_token", newJString(oauthToken))
  add(query_589022, "userIp", newJString(userIp))
  add(query_589022, "key", newJString(key))
  if body != nil:
    body_589023 = body
  add(query_589022, "prettyPrint", newJBool(prettyPrint))
  result = call_589021.call(nil, query_589022, nil, nil, body_589023)

var spectrumPawsNotifySpectrumUse* = Call_SpectrumPawsNotifySpectrumUse_589009(
    name: "spectrumPawsNotifySpectrumUse", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/notifySpectrumUse",
    validator: validate_SpectrumPawsNotifySpectrumUse_589010,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsNotifySpectrumUse_589011,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsRegister_589024 = ref object of OpenApiRestCall_588441
proc url_SpectrumPawsRegister_589026(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsRegister_589025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Google Spectrum Database implements registration in the getSpectrum method. As such this always returns an UNIMPLEMENTED error.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589027 = query.getOrDefault("fields")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "fields", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("userIp")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "userIp", valid_589031
  var valid_589032 = query.getOrDefault("key")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "key", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589035: Call_SpectrumPawsRegister_589024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Google Spectrum Database implements registration in the getSpectrum method. As such this always returns an UNIMPLEMENTED error.
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_SpectrumPawsRegister_589024; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spectrumPawsRegister
  ## The Google Spectrum Database implements registration in the getSpectrum method. As such this always returns an UNIMPLEMENTED error.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589037 = newJObject()
  var body_589038 = newJObject()
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "userIp", newJString(userIp))
  add(query_589037, "key", newJString(key))
  if body != nil:
    body_589038 = body
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(nil, query_589037, nil, nil, body_589038)

var spectrumPawsRegister* = Call_SpectrumPawsRegister_589024(
    name: "spectrumPawsRegister", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/register",
    validator: validate_SpectrumPawsRegister_589025,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsRegister_589026,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsVerifyDevice_589039 = ref object of OpenApiRestCall_588441
proc url_SpectrumPawsVerifyDevice_589041(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsVerifyDevice_589040(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates a device for white space use in accordance with regulatory rules. The Google Spectrum Database does not support master/slave configurations, so this always yields an UNIMPLEMENTED error.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589042 = query.getOrDefault("fields")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "fields", valid_589042
  var valid_589043 = query.getOrDefault("quotaUser")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "quotaUser", valid_589043
  var valid_589044 = query.getOrDefault("alt")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = newJString("json"))
  if valid_589044 != nil:
    section.add "alt", valid_589044
  var valid_589045 = query.getOrDefault("oauth_token")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "oauth_token", valid_589045
  var valid_589046 = query.getOrDefault("userIp")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "userIp", valid_589046
  var valid_589047 = query.getOrDefault("key")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "key", valid_589047
  var valid_589048 = query.getOrDefault("prettyPrint")
  valid_589048 = validateParameter(valid_589048, JBool, required = false,
                                 default = newJBool(true))
  if valid_589048 != nil:
    section.add "prettyPrint", valid_589048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589050: Call_SpectrumPawsVerifyDevice_589039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates a device for white space use in accordance with regulatory rules. The Google Spectrum Database does not support master/slave configurations, so this always yields an UNIMPLEMENTED error.
  ## 
  let valid = call_589050.validator(path, query, header, formData, body)
  let scheme = call_589050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589050.url(scheme.get, call_589050.host, call_589050.base,
                         call_589050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589050, url, valid)

proc call*(call_589051: Call_SpectrumPawsVerifyDevice_589039; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spectrumPawsVerifyDevice
  ## Validates a device for white space use in accordance with regulatory rules. The Google Spectrum Database does not support master/slave configurations, so this always yields an UNIMPLEMENTED error.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589052 = newJObject()
  var body_589053 = newJObject()
  add(query_589052, "fields", newJString(fields))
  add(query_589052, "quotaUser", newJString(quotaUser))
  add(query_589052, "alt", newJString(alt))
  add(query_589052, "oauth_token", newJString(oauthToken))
  add(query_589052, "userIp", newJString(userIp))
  add(query_589052, "key", newJString(key))
  if body != nil:
    body_589053 = body
  add(query_589052, "prettyPrint", newJBool(prettyPrint))
  result = call_589051.call(nil, query_589052, nil, nil, body_589053)

var spectrumPawsVerifyDevice* = Call_SpectrumPawsVerifyDevice_589039(
    name: "spectrumPawsVerifyDevice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyDevice",
    validator: validate_SpectrumPawsVerifyDevice_589040,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsVerifyDevice_589041,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
