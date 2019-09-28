
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Prediction
## version: v1.2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Lets you access a cloud hosted machine learning service that makes it easy to build smart apps
## 
## https://developers.google.com/prediction/docs/developer-guide
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
  gcpServiceName = "prediction"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PredictionHostedmodelsPredict_579677 = ref object of OpenApiRestCall_579408
proc url_PredictionHostedmodelsPredict_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "hostedModelName" in path, "`hostedModelName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/hostedmodels/"),
               (kind: VariableSegment, value: "hostedModelName"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionHostedmodelsPredict_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit input and request an output against a hosted model
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostedModelName: JString (required)
  ##                  : The name of a hosted model
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostedModelName` field"
  var valid_579805 = path.getOrDefault("hostedModelName")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "hostedModelName", valid_579805
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("oauth_token")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = nil)
  if valid_579822 != nil:
    section.add "oauth_token", valid_579822
  var valid_579823 = query.getOrDefault("userIp")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "userIp", valid_579823
  var valid_579824 = query.getOrDefault("key")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "key", valid_579824
  var valid_579825 = query.getOrDefault("prettyPrint")
  valid_579825 = validateParameter(valid_579825, JBool, required = false,
                                 default = newJBool(true))
  if valid_579825 != nil:
    section.add "prettyPrint", valid_579825
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

proc call*(call_579849: Call_PredictionHostedmodelsPredict_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit input and request an output against a hosted model
  ## 
  let valid = call_579849.validator(path, query, header, formData, body)
  let scheme = call_579849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579849.url(scheme.get, call_579849.host, call_579849.base,
                         call_579849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579849, url, valid)

proc call*(call_579920: Call_PredictionHostedmodelsPredict_579677;
          hostedModelName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionHostedmodelsPredict
  ## Submit input and request an output against a hosted model
  ##   hostedModelName: string (required)
  ##                  : The name of a hosted model
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579921 = newJObject()
  var query_579923 = newJObject()
  var body_579924 = newJObject()
  add(path_579921, "hostedModelName", newJString(hostedModelName))
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "key", newJString(key))
  if body != nil:
    body_579924 = body
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579920.call(path_579921, query_579923, nil, nil, body_579924)

var predictionHostedmodelsPredict* = Call_PredictionHostedmodelsPredict_579677(
    name: "predictionHostedmodelsPredict", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/hostedmodels/{hostedModelName}/predict",
    validator: validate_PredictionHostedmodelsPredict_579678,
    base: "/prediction/v1.2", url: url_PredictionHostedmodelsPredict_579679,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainingInsert_579963 = ref object of OpenApiRestCall_579408
proc url_PredictionTrainingInsert_579965(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PredictionTrainingInsert_579964(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begin training your model
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   data: JString
  ##       : mybucket/mydata resource in Google Storage
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("oauth_token")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "oauth_token", valid_579969
  var valid_579970 = query.getOrDefault("userIp")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "userIp", valid_579970
  var valid_579971 = query.getOrDefault("key")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "key", valid_579971
  var valid_579972 = query.getOrDefault("data")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "data", valid_579972
  var valid_579973 = query.getOrDefault("prettyPrint")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "prettyPrint", valid_579973
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

proc call*(call_579975: Call_PredictionTrainingInsert_579963; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin training your model
  ## 
  let valid = call_579975.validator(path, query, header, formData, body)
  let scheme = call_579975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579975.url(scheme.get, call_579975.host, call_579975.base,
                         call_579975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579975, url, valid)

proc call*(call_579976: Call_PredictionTrainingInsert_579963; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; data: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## predictionTrainingInsert
  ## Begin training your model
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   data: string
  ##       : mybucket/mydata resource in Google Storage
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579977 = newJObject()
  var body_579978 = newJObject()
  add(query_579977, "fields", newJString(fields))
  add(query_579977, "quotaUser", newJString(quotaUser))
  add(query_579977, "alt", newJString(alt))
  add(query_579977, "oauth_token", newJString(oauthToken))
  add(query_579977, "userIp", newJString(userIp))
  add(query_579977, "key", newJString(key))
  add(query_579977, "data", newJString(data))
  if body != nil:
    body_579978 = body
  add(query_579977, "prettyPrint", newJBool(prettyPrint))
  result = call_579976.call(nil, query_579977, nil, nil, body_579978)

var predictionTrainingInsert* = Call_PredictionTrainingInsert_579963(
    name: "predictionTrainingInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/training",
    validator: validate_PredictionTrainingInsert_579964, base: "/prediction/v1.2",
    url: url_PredictionTrainingInsert_579965, schemes: {Scheme.Https})
type
  Call_PredictionTrainingUpdate_579994 = ref object of OpenApiRestCall_579408
proc url_PredictionTrainingUpdate_579996(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "data" in path, "`data` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/training/"),
               (kind: VariableSegment, value: "data")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainingUpdate_579995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add new data to a trained model
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   data: JString (required)
  ##       : mybucket/mydata resource in Google Storage
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `data` field"
  var valid_579997 = path.getOrDefault("data")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "data", valid_579997
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("key")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "key", valid_580003
  var valid_580004 = query.getOrDefault("prettyPrint")
  valid_580004 = validateParameter(valid_580004, JBool, required = false,
                                 default = newJBool(true))
  if valid_580004 != nil:
    section.add "prettyPrint", valid_580004
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

proc call*(call_580006: Call_PredictionTrainingUpdate_579994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add new data to a trained model
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_PredictionTrainingUpdate_579994; data: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionTrainingUpdate
  ## Add new data to a trained model
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   data: string (required)
  ##       : mybucket/mydata resource in Google Storage
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  var body_580010 = newJObject()
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "key", newJString(key))
  add(path_580008, "data", newJString(data))
  if body != nil:
    body_580010 = body
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, body_580010)

var predictionTrainingUpdate* = Call_PredictionTrainingUpdate_579994(
    name: "predictionTrainingUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/training/{data}",
    validator: validate_PredictionTrainingUpdate_579995, base: "/prediction/v1.2",
    url: url_PredictionTrainingUpdate_579996, schemes: {Scheme.Https})
type
  Call_PredictionTrainingGet_579979 = ref object of OpenApiRestCall_579408
proc url_PredictionTrainingGet_579981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "data" in path, "`data` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/training/"),
               (kind: VariableSegment, value: "data")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainingGet_579980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check training status of your model
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   data: JString (required)
  ##       : mybucket/mydata resource in Google Storage
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `data` field"
  var valid_579982 = path.getOrDefault("data")
  valid_579982 = validateParameter(valid_579982, JString, required = true,
                                 default = nil)
  if valid_579982 != nil:
    section.add "data", valid_579982
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579983 = query.getOrDefault("fields")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "fields", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("userIp")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "userIp", valid_579987
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579990: Call_PredictionTrainingGet_579979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check training status of your model
  ## 
  let valid = call_579990.validator(path, query, header, formData, body)
  let scheme = call_579990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579990.url(scheme.get, call_579990.host, call_579990.base,
                         call_579990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579990, url, valid)

proc call*(call_579991: Call_PredictionTrainingGet_579979; data: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## predictionTrainingGet
  ## Check training status of your model
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   data: string (required)
  ##       : mybucket/mydata resource in Google Storage
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579992 = newJObject()
  var query_579993 = newJObject()
  add(query_579993, "fields", newJString(fields))
  add(query_579993, "quotaUser", newJString(quotaUser))
  add(query_579993, "alt", newJString(alt))
  add(query_579993, "oauth_token", newJString(oauthToken))
  add(query_579993, "userIp", newJString(userIp))
  add(query_579993, "key", newJString(key))
  add(path_579992, "data", newJString(data))
  add(query_579993, "prettyPrint", newJBool(prettyPrint))
  result = call_579991.call(path_579992, query_579993, nil, nil, nil)

var predictionTrainingGet* = Call_PredictionTrainingGet_579979(
    name: "predictionTrainingGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/training/{data}",
    validator: validate_PredictionTrainingGet_579980, base: "/prediction/v1.2",
    url: url_PredictionTrainingGet_579981, schemes: {Scheme.Https})
type
  Call_PredictionTrainingDelete_580011 = ref object of OpenApiRestCall_579408
proc url_PredictionTrainingDelete_580013(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "data" in path, "`data` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/training/"),
               (kind: VariableSegment, value: "data")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainingDelete_580012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a trained model
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   data: JString (required)
  ##       : mybucket/mydata resource in Google Storage
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `data` field"
  var valid_580014 = path.getOrDefault("data")
  valid_580014 = validateParameter(valid_580014, JString, required = true,
                                 default = nil)
  if valid_580014 != nil:
    section.add "data", valid_580014
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580015 = query.getOrDefault("fields")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "fields", valid_580015
  var valid_580016 = query.getOrDefault("quotaUser")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "quotaUser", valid_580016
  var valid_580017 = query.getOrDefault("alt")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = newJString("json"))
  if valid_580017 != nil:
    section.add "alt", valid_580017
  var valid_580018 = query.getOrDefault("oauth_token")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "oauth_token", valid_580018
  var valid_580019 = query.getOrDefault("userIp")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "userIp", valid_580019
  var valid_580020 = query.getOrDefault("key")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "key", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_PredictionTrainingDelete_580011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a trained model
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_PredictionTrainingDelete_580011; data: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## predictionTrainingDelete
  ## Delete a trained model
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   data: string (required)
  ##       : mybucket/mydata resource in Google Storage
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580024 = newJObject()
  var query_580025 = newJObject()
  add(query_580025, "fields", newJString(fields))
  add(query_580025, "quotaUser", newJString(quotaUser))
  add(query_580025, "alt", newJString(alt))
  add(query_580025, "oauth_token", newJString(oauthToken))
  add(query_580025, "userIp", newJString(userIp))
  add(query_580025, "key", newJString(key))
  add(path_580024, "data", newJString(data))
  add(query_580025, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(path_580024, query_580025, nil, nil, nil)

var predictionTrainingDelete* = Call_PredictionTrainingDelete_580011(
    name: "predictionTrainingDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/training/{data}",
    validator: validate_PredictionTrainingDelete_580012, base: "/prediction/v1.2",
    url: url_PredictionTrainingDelete_580013, schemes: {Scheme.Https})
type
  Call_PredictionPredict_580026 = ref object of OpenApiRestCall_579408
proc url_PredictionPredict_580028(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "data" in path, "`data` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/training/"),
               (kind: VariableSegment, value: "data"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionPredict_580027(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Submit data and request a prediction
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   data: JString (required)
  ##       : mybucket%2Fmydata resource in Google Storage
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `data` field"
  var valid_580029 = path.getOrDefault("data")
  valid_580029 = validateParameter(valid_580029, JString, required = true,
                                 default = nil)
  if valid_580029 != nil:
    section.add "data", valid_580029
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580030 = query.getOrDefault("fields")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "fields", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("alt")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = newJString("json"))
  if valid_580032 != nil:
    section.add "alt", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("userIp")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "userIp", valid_580034
  var valid_580035 = query.getOrDefault("key")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "key", valid_580035
  var valid_580036 = query.getOrDefault("prettyPrint")
  valid_580036 = validateParameter(valid_580036, JBool, required = false,
                                 default = newJBool(true))
  if valid_580036 != nil:
    section.add "prettyPrint", valid_580036
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

proc call*(call_580038: Call_PredictionPredict_580026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit data and request a prediction
  ## 
  let valid = call_580038.validator(path, query, header, formData, body)
  let scheme = call_580038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580038.url(scheme.get, call_580038.host, call_580038.base,
                         call_580038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580038, url, valid)

proc call*(call_580039: Call_PredictionPredict_580026; data: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionPredict
  ## Submit data and request a prediction
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   data: string (required)
  ##       : mybucket%2Fmydata resource in Google Storage
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580040 = newJObject()
  var query_580041 = newJObject()
  var body_580042 = newJObject()
  add(query_580041, "fields", newJString(fields))
  add(query_580041, "quotaUser", newJString(quotaUser))
  add(query_580041, "alt", newJString(alt))
  add(query_580041, "oauth_token", newJString(oauthToken))
  add(query_580041, "userIp", newJString(userIp))
  add(query_580041, "key", newJString(key))
  add(path_580040, "data", newJString(data))
  if body != nil:
    body_580042 = body
  add(query_580041, "prettyPrint", newJBool(prettyPrint))
  result = call_580039.call(path_580040, query_580041, nil, nil, body_580042)

var predictionPredict* = Call_PredictionPredict_580026(name: "predictionPredict",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/training/{data}/predict", validator: validate_PredictionPredict_580027,
    base: "/prediction/v1.2", url: url_PredictionPredict_580028,
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
