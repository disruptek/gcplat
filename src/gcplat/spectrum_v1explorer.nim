
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_SpectrumPawsGetSpectrum_579676 = ref object of OpenApiRestCall_579408
proc url_SpectrumPawsGetSpectrum_579678(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsGetSpectrum_579677(path: JsonNode; query: JsonNode;
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
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("key")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "key", valid_579808
  var valid_579809 = query.getOrDefault("prettyPrint")
  valid_579809 = validateParameter(valid_579809, JBool, required = false,
                                 default = newJBool(true))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
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

proc call*(call_579833: Call_SpectrumPawsGetSpectrum_579676; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests information about the available spectrum for a device at a location. Requests from a fixed-mode device must include owner information so the device can be registered with the database.
  ## 
  let valid = call_579833.validator(path, query, header, formData, body)
  let scheme = call_579833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579833.url(scheme.get, call_579833.host, call_579833.base,
                         call_579833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579833, url, valid)

proc call*(call_579904: Call_SpectrumPawsGetSpectrum_579676; fields: string = "";
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
  var query_579905 = newJObject()
  var body_579907 = newJObject()
  add(query_579905, "fields", newJString(fields))
  add(query_579905, "quotaUser", newJString(quotaUser))
  add(query_579905, "alt", newJString(alt))
  add(query_579905, "oauth_token", newJString(oauthToken))
  add(query_579905, "userIp", newJString(userIp))
  add(query_579905, "key", newJString(key))
  if body != nil:
    body_579907 = body
  add(query_579905, "prettyPrint", newJBool(prettyPrint))
  result = call_579904.call(nil, query_579905, nil, nil, body_579907)

var spectrumPawsGetSpectrum* = Call_SpectrumPawsGetSpectrum_579676(
    name: "spectrumPawsGetSpectrum", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getSpectrum",
    validator: validate_SpectrumPawsGetSpectrum_579677,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsGetSpectrum_579678,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsGetSpectrumBatch_579946 = ref object of OpenApiRestCall_579408
proc url_SpectrumPawsGetSpectrumBatch_579948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsGetSpectrumBatch_579947(path: JsonNode; query: JsonNode;
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
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("userIp")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "userIp", valid_579953
  var valid_579954 = query.getOrDefault("key")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "key", valid_579954
  var valid_579955 = query.getOrDefault("prettyPrint")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(true))
  if valid_579955 != nil:
    section.add "prettyPrint", valid_579955
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

proc call*(call_579957: Call_SpectrumPawsGetSpectrumBatch_579946; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Google Spectrum Database does not support batch requests, so this method always yields an UNIMPLEMENTED error.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_SpectrumPawsGetSpectrumBatch_579946;
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
  var query_579959 = newJObject()
  var body_579960 = newJObject()
  add(query_579959, "fields", newJString(fields))
  add(query_579959, "quotaUser", newJString(quotaUser))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "userIp", newJString(userIp))
  add(query_579959, "key", newJString(key))
  if body != nil:
    body_579960 = body
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  result = call_579958.call(nil, query_579959, nil, nil, body_579960)

var spectrumPawsGetSpectrumBatch* = Call_SpectrumPawsGetSpectrumBatch_579946(
    name: "spectrumPawsGetSpectrumBatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/getSpectrumBatch",
    validator: validate_SpectrumPawsGetSpectrumBatch_579947,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsGetSpectrumBatch_579948,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsInit_579961 = ref object of OpenApiRestCall_579408
proc url_SpectrumPawsInit_579963(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsInit_579962(path: JsonNode; query: JsonNode;
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
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
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

proc call*(call_579972: Call_SpectrumPawsInit_579961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Initializes the connection between a white space device and the database.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_SpectrumPawsInit_579961; fields: string = "";
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
  var query_579974 = newJObject()
  var body_579975 = newJObject()
  add(query_579974, "fields", newJString(fields))
  add(query_579974, "quotaUser", newJString(quotaUser))
  add(query_579974, "alt", newJString(alt))
  add(query_579974, "oauth_token", newJString(oauthToken))
  add(query_579974, "userIp", newJString(userIp))
  add(query_579974, "key", newJString(key))
  if body != nil:
    body_579975 = body
  add(query_579974, "prettyPrint", newJBool(prettyPrint))
  result = call_579973.call(nil, query_579974, nil, nil, body_579975)

var spectrumPawsInit* = Call_SpectrumPawsInit_579961(name: "spectrumPawsInit",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/init",
    validator: validate_SpectrumPawsInit_579962,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsInit_579963,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsNotifySpectrumUse_579976 = ref object of OpenApiRestCall_579408
proc url_SpectrumPawsNotifySpectrumUse_579978(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsNotifySpectrumUse_579977(path: JsonNode; query: JsonNode;
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
  var valid_579979 = query.getOrDefault("fields")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "fields", valid_579979
  var valid_579980 = query.getOrDefault("quotaUser")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "quotaUser", valid_579980
  var valid_579981 = query.getOrDefault("alt")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = newJString("json"))
  if valid_579981 != nil:
    section.add "alt", valid_579981
  var valid_579982 = query.getOrDefault("oauth_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "oauth_token", valid_579982
  var valid_579983 = query.getOrDefault("userIp")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "userIp", valid_579983
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("prettyPrint")
  valid_579985 = validateParameter(valid_579985, JBool, required = false,
                                 default = newJBool(true))
  if valid_579985 != nil:
    section.add "prettyPrint", valid_579985
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

proc call*(call_579987: Call_SpectrumPawsNotifySpectrumUse_579976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Notifies the database that the device has selected certain frequency ranges for transmission. Only to be invoked when required by the regulator. The Google Spectrum Database does not operate in domains that require notification, so this always yields an UNIMPLEMENTED error.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_SpectrumPawsNotifySpectrumUse_579976;
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
  var query_579989 = newJObject()
  var body_579990 = newJObject()
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "userIp", newJString(userIp))
  add(query_579989, "key", newJString(key))
  if body != nil:
    body_579990 = body
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(nil, query_579989, nil, nil, body_579990)

var spectrumPawsNotifySpectrumUse* = Call_SpectrumPawsNotifySpectrumUse_579976(
    name: "spectrumPawsNotifySpectrumUse", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/notifySpectrumUse",
    validator: validate_SpectrumPawsNotifySpectrumUse_579977,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsNotifySpectrumUse_579978,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsRegister_579991 = ref object of OpenApiRestCall_579408
proc url_SpectrumPawsRegister_579993(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsRegister_579992(path: JsonNode; query: JsonNode;
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
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("userIp")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "userIp", valid_579998
  var valid_579999 = query.getOrDefault("key")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "key", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
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

proc call*(call_580002: Call_SpectrumPawsRegister_579991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Google Spectrum Database implements registration in the getSpectrum method. As such this always returns an UNIMPLEMENTED error.
  ## 
  let valid = call_580002.validator(path, query, header, formData, body)
  let scheme = call_580002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580002.url(scheme.get, call_580002.host, call_580002.base,
                         call_580002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580002, url, valid)

proc call*(call_580003: Call_SpectrumPawsRegister_579991; fields: string = "";
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
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "userIp", newJString(userIp))
  add(query_580004, "key", newJString(key))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580003.call(nil, query_580004, nil, nil, body_580005)

var spectrumPawsRegister* = Call_SpectrumPawsRegister_579991(
    name: "spectrumPawsRegister", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/register",
    validator: validate_SpectrumPawsRegister_579992,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsRegister_579993,
    schemes: {Scheme.Https})
type
  Call_SpectrumPawsVerifyDevice_580006 = ref object of OpenApiRestCall_579408
proc url_SpectrumPawsVerifyDevice_580008(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_SpectrumPawsVerifyDevice_580007(path: JsonNode; query: JsonNode;
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
  var valid_580009 = query.getOrDefault("fields")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "fields", valid_580009
  var valid_580010 = query.getOrDefault("quotaUser")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "quotaUser", valid_580010
  var valid_580011 = query.getOrDefault("alt")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = newJString("json"))
  if valid_580011 != nil:
    section.add "alt", valid_580011
  var valid_580012 = query.getOrDefault("oauth_token")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "oauth_token", valid_580012
  var valid_580013 = query.getOrDefault("userIp")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "userIp", valid_580013
  var valid_580014 = query.getOrDefault("key")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "key", valid_580014
  var valid_580015 = query.getOrDefault("prettyPrint")
  valid_580015 = validateParameter(valid_580015, JBool, required = false,
                                 default = newJBool(true))
  if valid_580015 != nil:
    section.add "prettyPrint", valid_580015
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

proc call*(call_580017: Call_SpectrumPawsVerifyDevice_580006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates a device for white space use in accordance with regulatory rules. The Google Spectrum Database does not support master/slave configurations, so this always yields an UNIMPLEMENTED error.
  ## 
  let valid = call_580017.validator(path, query, header, formData, body)
  let scheme = call_580017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580017.url(scheme.get, call_580017.host, call_580017.base,
                         call_580017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580017, url, valid)

proc call*(call_580018: Call_SpectrumPawsVerifyDevice_580006; fields: string = "";
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
  var query_580019 = newJObject()
  var body_580020 = newJObject()
  add(query_580019, "fields", newJString(fields))
  add(query_580019, "quotaUser", newJString(quotaUser))
  add(query_580019, "alt", newJString(alt))
  add(query_580019, "oauth_token", newJString(oauthToken))
  add(query_580019, "userIp", newJString(userIp))
  add(query_580019, "key", newJString(key))
  if body != nil:
    body_580020 = body
  add(query_580019, "prettyPrint", newJBool(prettyPrint))
  result = call_580018.call(nil, query_580019, nil, nil, body_580020)

var spectrumPawsVerifyDevice* = Call_SpectrumPawsVerifyDevice_580006(
    name: "spectrumPawsVerifyDevice", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/verifyDevice",
    validator: validate_SpectrumPawsVerifyDevice_580007,
    base: "/spectrum/v1explorer/paws", url: url_SpectrumPawsVerifyDevice_580008,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
