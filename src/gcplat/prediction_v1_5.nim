
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Prediction
## version: v1.5
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PredictionHostedmodelsPredict_593693 = ref object of OpenApiRestCall_593424
proc url_PredictionHostedmodelsPredict_593695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PredictionHostedmodelsPredict_593694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit input and request an output against a hosted model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   hostedModelName: JString (required)
  ##                  : The name of a hosted model.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `hostedModelName` field"
  var valid_593821 = path.getOrDefault("hostedModelName")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "hostedModelName", valid_593821
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
  var valid_593822 = query.getOrDefault("fields")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = nil)
  if valid_593822 != nil:
    section.add "fields", valid_593822
  var valid_593823 = query.getOrDefault("quotaUser")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "quotaUser", valid_593823
  var valid_593837 = query.getOrDefault("alt")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = newJString("json"))
  if valid_593837 != nil:
    section.add "alt", valid_593837
  var valid_593838 = query.getOrDefault("oauth_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "oauth_token", valid_593838
  var valid_593839 = query.getOrDefault("userIp")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "userIp", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("prettyPrint")
  valid_593841 = validateParameter(valid_593841, JBool, required = false,
                                 default = newJBool(true))
  if valid_593841 != nil:
    section.add "prettyPrint", valid_593841
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

proc call*(call_593865: Call_PredictionHostedmodelsPredict_593693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit input and request an output against a hosted model.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_PredictionHostedmodelsPredict_593693;
          hostedModelName: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionHostedmodelsPredict
  ## Submit input and request an output against a hosted model.
  ##   hostedModelName: string (required)
  ##                  : The name of a hosted model.
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
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  var body_593940 = newJObject()
  add(path_593937, "hostedModelName", newJString(hostedModelName))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "userIp", newJString(userIp))
  add(query_593939, "key", newJString(key))
  if body != nil:
    body_593940 = body
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, body_593940)

var predictionHostedmodelsPredict* = Call_PredictionHostedmodelsPredict_593693(
    name: "predictionHostedmodelsPredict", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/hostedmodels/{hostedModelName}/predict",
    validator: validate_PredictionHostedmodelsPredict_593694,
    base: "/prediction/v1.5", url: url_PredictionHostedmodelsPredict_593695,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsInsert_593979 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsInsert_593981(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PredictionTrainedmodelsInsert_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Begin training your model.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593982 = query.getOrDefault("fields")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "fields", valid_593982
  var valid_593983 = query.getOrDefault("quotaUser")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "quotaUser", valid_593983
  var valid_593984 = query.getOrDefault("alt")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = newJString("json"))
  if valid_593984 != nil:
    section.add "alt", valid_593984
  var valid_593985 = query.getOrDefault("oauth_token")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "oauth_token", valid_593985
  var valid_593986 = query.getOrDefault("userIp")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "userIp", valid_593986
  var valid_593987 = query.getOrDefault("key")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "key", valid_593987
  var valid_593988 = query.getOrDefault("prettyPrint")
  valid_593988 = validateParameter(valid_593988, JBool, required = false,
                                 default = newJBool(true))
  if valid_593988 != nil:
    section.add "prettyPrint", valid_593988
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

proc call*(call_593990: Call_PredictionTrainedmodelsInsert_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Begin training your model.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_PredictionTrainedmodelsInsert_593979;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsInsert
  ## Begin training your model.
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
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(query_593992, "fields", newJString(fields))
  add(query_593992, "quotaUser", newJString(quotaUser))
  add(query_593992, "alt", newJString(alt))
  add(query_593992, "oauth_token", newJString(oauthToken))
  add(query_593992, "userIp", newJString(userIp))
  add(query_593992, "key", newJString(key))
  if body != nil:
    body_593993 = body
  add(query_593992, "prettyPrint", newJBool(prettyPrint))
  result = call_593991.call(nil, query_593992, nil, nil, body_593993)

var predictionTrainedmodelsInsert* = Call_PredictionTrainedmodelsInsert_593979(
    name: "predictionTrainedmodelsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/trainedmodels",
    validator: validate_PredictionTrainedmodelsInsert_593980,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsInsert_593981,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsList_593994 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsList_593996(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PredictionTrainedmodelsList_593995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List available models.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Pagination token
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: JInt
  ##             : Maximum number of results to return
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593997 = query.getOrDefault("fields")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "fields", valid_593997
  var valid_593998 = query.getOrDefault("pageToken")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "pageToken", valid_593998
  var valid_593999 = query.getOrDefault("quotaUser")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "quotaUser", valid_593999
  var valid_594000 = query.getOrDefault("alt")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = newJString("json"))
  if valid_594000 != nil:
    section.add "alt", valid_594000
  var valid_594001 = query.getOrDefault("oauth_token")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "oauth_token", valid_594001
  var valid_594002 = query.getOrDefault("userIp")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "userIp", valid_594002
  var valid_594003 = query.getOrDefault("maxResults")
  valid_594003 = validateParameter(valid_594003, JInt, required = false, default = nil)
  if valid_594003 != nil:
    section.add "maxResults", valid_594003
  var valid_594004 = query.getOrDefault("key")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "key", valid_594004
  var valid_594005 = query.getOrDefault("prettyPrint")
  valid_594005 = validateParameter(valid_594005, JBool, required = false,
                                 default = newJBool(true))
  if valid_594005 != nil:
    section.add "prettyPrint", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_PredictionTrainedmodelsList_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List available models.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_PredictionTrainedmodelsList_593994;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsList
  ## List available models.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Pagination token
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters. Overrides userIp if both are provided.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : IP address of the site where the request originates. Use this if you want to enforce per-user limits.
  ##   maxResults: int
  ##             : Maximum number of results to return
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594008 = newJObject()
  add(query_594008, "fields", newJString(fields))
  add(query_594008, "pageToken", newJString(pageToken))
  add(query_594008, "quotaUser", newJString(quotaUser))
  add(query_594008, "alt", newJString(alt))
  add(query_594008, "oauth_token", newJString(oauthToken))
  add(query_594008, "userIp", newJString(userIp))
  add(query_594008, "maxResults", newJInt(maxResults))
  add(query_594008, "key", newJString(key))
  add(query_594008, "prettyPrint", newJBool(prettyPrint))
  result = call_594007.call(nil, query_594008, nil, nil, nil)

var predictionTrainedmodelsList* = Call_PredictionTrainedmodelsList_593994(
    name: "predictionTrainedmodelsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/trainedmodels/list",
    validator: validate_PredictionTrainedmodelsList_593995,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsList_593996,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsUpdate_594024 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsUpdate_594026(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/trainedmodels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainedmodelsUpdate_594025(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add new data to a trained model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The unique name for the predictive model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_594027 = path.getOrDefault("id")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "id", valid_594027
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
  var valid_594028 = query.getOrDefault("fields")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "fields", valid_594028
  var valid_594029 = query.getOrDefault("quotaUser")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "quotaUser", valid_594029
  var valid_594030 = query.getOrDefault("alt")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = newJString("json"))
  if valid_594030 != nil:
    section.add "alt", valid_594030
  var valid_594031 = query.getOrDefault("oauth_token")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "oauth_token", valid_594031
  var valid_594032 = query.getOrDefault("userIp")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "userIp", valid_594032
  var valid_594033 = query.getOrDefault("key")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "key", valid_594033
  var valid_594034 = query.getOrDefault("prettyPrint")
  valid_594034 = validateParameter(valid_594034, JBool, required = false,
                                 default = newJBool(true))
  if valid_594034 != nil:
    section.add "prettyPrint", valid_594034
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

proc call*(call_594036: Call_PredictionTrainedmodelsUpdate_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add new data to a trained model.
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_PredictionTrainedmodelsUpdate_594024; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsUpdate
  ## Add new data to a trained model.
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
  ##   id: string (required)
  ##     : The unique name for the predictive model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  var body_594040 = newJObject()
  add(query_594039, "fields", newJString(fields))
  add(query_594039, "quotaUser", newJString(quotaUser))
  add(query_594039, "alt", newJString(alt))
  add(query_594039, "oauth_token", newJString(oauthToken))
  add(query_594039, "userIp", newJString(userIp))
  add(path_594038, "id", newJString(id))
  add(query_594039, "key", newJString(key))
  if body != nil:
    body_594040 = body
  add(query_594039, "prettyPrint", newJBool(prettyPrint))
  result = call_594037.call(path_594038, query_594039, nil, nil, body_594040)

var predictionTrainedmodelsUpdate* = Call_PredictionTrainedmodelsUpdate_594024(
    name: "predictionTrainedmodelsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/trainedmodels/{id}",
    validator: validate_PredictionTrainedmodelsUpdate_594025,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsUpdate_594026,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsGet_594009 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsGet_594011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/trainedmodels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainedmodelsGet_594010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check training status of your model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The unique name for the predictive model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_594012 = path.getOrDefault("id")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "id", valid_594012
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
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("oauth_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "oauth_token", valid_594016
  var valid_594017 = query.getOrDefault("userIp")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "userIp", valid_594017
  var valid_594018 = query.getOrDefault("key")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "key", valid_594018
  var valid_594019 = query.getOrDefault("prettyPrint")
  valid_594019 = validateParameter(valid_594019, JBool, required = false,
                                 default = newJBool(true))
  if valid_594019 != nil:
    section.add "prettyPrint", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_PredictionTrainedmodelsGet_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check training status of your model.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_PredictionTrainedmodelsGet_594009; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsGet
  ## Check training status of your model.
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
  ##   id: string (required)
  ##     : The unique name for the predictive model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(query_594023, "fields", newJString(fields))
  add(query_594023, "quotaUser", newJString(quotaUser))
  add(query_594023, "alt", newJString(alt))
  add(query_594023, "oauth_token", newJString(oauthToken))
  add(query_594023, "userIp", newJString(userIp))
  add(path_594022, "id", newJString(id))
  add(query_594023, "key", newJString(key))
  add(query_594023, "prettyPrint", newJBool(prettyPrint))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var predictionTrainedmodelsGet* = Call_PredictionTrainedmodelsGet_594009(
    name: "predictionTrainedmodelsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/trainedmodels/{id}",
    validator: validate_PredictionTrainedmodelsGet_594010,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsGet_594011,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsDelete_594041 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsDelete_594043(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/trainedmodels/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainedmodelsDelete_594042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a trained model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The unique name for the predictive model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_594044 = path.getOrDefault("id")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "id", valid_594044
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
  var valid_594045 = query.getOrDefault("fields")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "fields", valid_594045
  var valid_594046 = query.getOrDefault("quotaUser")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "quotaUser", valid_594046
  var valid_594047 = query.getOrDefault("alt")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("json"))
  if valid_594047 != nil:
    section.add "alt", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("userIp")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "userIp", valid_594049
  var valid_594050 = query.getOrDefault("key")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "key", valid_594050
  var valid_594051 = query.getOrDefault("prettyPrint")
  valid_594051 = validateParameter(valid_594051, JBool, required = false,
                                 default = newJBool(true))
  if valid_594051 != nil:
    section.add "prettyPrint", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_PredictionTrainedmodelsDelete_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a trained model.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_PredictionTrainedmodelsDelete_594041; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsDelete
  ## Delete a trained model.
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
  ##   id: string (required)
  ##     : The unique name for the predictive model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594054 = newJObject()
  var query_594055 = newJObject()
  add(query_594055, "fields", newJString(fields))
  add(query_594055, "quotaUser", newJString(quotaUser))
  add(query_594055, "alt", newJString(alt))
  add(query_594055, "oauth_token", newJString(oauthToken))
  add(query_594055, "userIp", newJString(userIp))
  add(path_594054, "id", newJString(id))
  add(query_594055, "key", newJString(key))
  add(query_594055, "prettyPrint", newJBool(prettyPrint))
  result = call_594053.call(path_594054, query_594055, nil, nil, nil)

var predictionTrainedmodelsDelete* = Call_PredictionTrainedmodelsDelete_594041(
    name: "predictionTrainedmodelsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/trainedmodels/{id}",
    validator: validate_PredictionTrainedmodelsDelete_594042,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsDelete_594043,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsAnalyze_594056 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsAnalyze_594058(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/trainedmodels/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/analyze")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainedmodelsAnalyze_594057(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get analysis of the model and the data the model was trained on.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The unique name for the predictive model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_594059 = path.getOrDefault("id")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "id", valid_594059
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
  var valid_594060 = query.getOrDefault("fields")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "fields", valid_594060
  var valid_594061 = query.getOrDefault("quotaUser")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "quotaUser", valid_594061
  var valid_594062 = query.getOrDefault("alt")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = newJString("json"))
  if valid_594062 != nil:
    section.add "alt", valid_594062
  var valid_594063 = query.getOrDefault("oauth_token")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "oauth_token", valid_594063
  var valid_594064 = query.getOrDefault("userIp")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "userIp", valid_594064
  var valid_594065 = query.getOrDefault("key")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "key", valid_594065
  var valid_594066 = query.getOrDefault("prettyPrint")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "prettyPrint", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_PredictionTrainedmodelsAnalyze_594056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get analysis of the model and the data the model was trained on.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_PredictionTrainedmodelsAnalyze_594056; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsAnalyze
  ## Get analysis of the model and the data the model was trained on.
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
  ##   id: string (required)
  ##     : The unique name for the predictive model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(path_594069, "id", newJString(id))
  add(query_594070, "key", newJString(key))
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var predictionTrainedmodelsAnalyze* = Call_PredictionTrainedmodelsAnalyze_594056(
    name: "predictionTrainedmodelsAnalyze", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/trainedmodels/{id}/analyze",
    validator: validate_PredictionTrainedmodelsAnalyze_594057,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsAnalyze_594058,
    schemes: {Scheme.Https})
type
  Call_PredictionTrainedmodelsPredict_594071 = ref object of OpenApiRestCall_593424
proc url_PredictionTrainedmodelsPredict_594073(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/trainedmodels/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/predict")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PredictionTrainedmodelsPredict_594072(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Submit model id and request a prediction.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : The unique name for the predictive model.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_594074 = path.getOrDefault("id")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "id", valid_594074
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
  var valid_594075 = query.getOrDefault("fields")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "fields", valid_594075
  var valid_594076 = query.getOrDefault("quotaUser")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "quotaUser", valid_594076
  var valid_594077 = query.getOrDefault("alt")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = newJString("json"))
  if valid_594077 != nil:
    section.add "alt", valid_594077
  var valid_594078 = query.getOrDefault("oauth_token")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "oauth_token", valid_594078
  var valid_594079 = query.getOrDefault("userIp")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "userIp", valid_594079
  var valid_594080 = query.getOrDefault("key")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "key", valid_594080
  var valid_594081 = query.getOrDefault("prettyPrint")
  valid_594081 = validateParameter(valid_594081, JBool, required = false,
                                 default = newJBool(true))
  if valid_594081 != nil:
    section.add "prettyPrint", valid_594081
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

proc call*(call_594083: Call_PredictionTrainedmodelsPredict_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Submit model id and request a prediction.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_PredictionTrainedmodelsPredict_594071; id: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## predictionTrainedmodelsPredict
  ## Submit model id and request a prediction.
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
  ##   id: string (required)
  ##     : The unique name for the predictive model.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  var body_594087 = newJObject()
  add(query_594086, "fields", newJString(fields))
  add(query_594086, "quotaUser", newJString(quotaUser))
  add(query_594086, "alt", newJString(alt))
  add(query_594086, "oauth_token", newJString(oauthToken))
  add(query_594086, "userIp", newJString(userIp))
  add(path_594085, "id", newJString(id))
  add(query_594086, "key", newJString(key))
  if body != nil:
    body_594087 = body
  add(query_594086, "prettyPrint", newJBool(prettyPrint))
  result = call_594084.call(path_594085, query_594086, nil, nil, body_594087)

var predictionTrainedmodelsPredict* = Call_PredictionTrainedmodelsPredict_594071(
    name: "predictionTrainedmodelsPredict", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/trainedmodels/{id}/predict",
    validator: validate_PredictionTrainedmodelsPredict_594072,
    base: "/prediction/v1.5", url: url_PredictionTrainedmodelsPredict_594073,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
