
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Dialogflow
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Builds conversational interfaces (for example, chatbots, and voice-powered apps and devices).
## 
## https://cloud.google.com/dialogflow/
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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "dialogflow"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DialogflowProjectsLocationsOperationsGet_578619 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsLocationsOperationsGet_578621(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsLocationsOperationsGet_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional. The language to retrieve training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("intentView")
  valid_578768 = validateParameter(valid_578768, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_578768 != nil:
    section.add "intentView", valid_578768
  var valid_578769 = query.getOrDefault("callback")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "callback", valid_578769
  var valid_578770 = query.getOrDefault("languageCode")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "languageCode", valid_578770
  var valid_578771 = query.getOrDefault("fields")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "fields", valid_578771
  var valid_578772 = query.getOrDefault("access_token")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = nil)
  if valid_578772 != nil:
    section.add "access_token", valid_578772
  var valid_578773 = query.getOrDefault("upload_protocol")
  valid_578773 = validateParameter(valid_578773, JString, required = false,
                                 default = nil)
  if valid_578773 != nil:
    section.add "upload_protocol", valid_578773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578796: Call_DialogflowProjectsLocationsOperationsGet_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578796.validator(path, query, header, formData, body)
  let scheme = call_578796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578796.url(scheme.get, call_578796.host, call_578796.base,
                         call_578796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578796, url, valid)

proc call*(call_578867: Call_DialogflowProjectsLocationsOperationsGet_578619;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          intentView: string = "INTENT_VIEW_UNSPECIFIED"; callback: string = "";
          languageCode: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsLocationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional. The language to retrieve training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578868 = newJObject()
  var query_578870 = newJObject()
  add(query_578870, "key", newJString(key))
  add(query_578870, "prettyPrint", newJBool(prettyPrint))
  add(query_578870, "oauth_token", newJString(oauthToken))
  add(query_578870, "$.xgafv", newJString(Xgafv))
  add(query_578870, "alt", newJString(alt))
  add(query_578870, "uploadType", newJString(uploadType))
  add(query_578870, "quotaUser", newJString(quotaUser))
  add(path_578868, "name", newJString(name))
  add(query_578870, "intentView", newJString(intentView))
  add(query_578870, "callback", newJString(callback))
  add(query_578870, "languageCode", newJString(languageCode))
  add(query_578870, "fields", newJString(fields))
  add(query_578870, "access_token", newJString(accessToken))
  add(query_578870, "upload_protocol", newJString(uploadProtocol))
  result = call_578867.call(path_578868, query_578870, nil, nil, nil)

var dialogflowProjectsLocationsOperationsGet* = Call_DialogflowProjectsLocationsOperationsGet_578619(
    name: "dialogflowProjectsLocationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{name}",
    validator: validate_DialogflowProjectsLocationsOperationsGet_578620,
    base: "/", url: url_DialogflowProjectsLocationsOperationsGet_578621,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsPatch_578928 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentIntentsPatch_578930(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsPatch_578929(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified intent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique identifier of this intent.
  ## Required for Intents.UpdateIntent and Intents.BatchUpdateIntents
  ## methods.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578931 = path.getOrDefault("name")
  valid_578931 = validateParameter(valid_578931, JString, required = true,
                                 default = nil)
  if valid_578931 != nil:
    section.add "name", valid_578931
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Optional. The mask to control which fields get updated.
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578932 = query.getOrDefault("key")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "key", valid_578932
  var valid_578933 = query.getOrDefault("prettyPrint")
  valid_578933 = validateParameter(valid_578933, JBool, required = false,
                                 default = newJBool(true))
  if valid_578933 != nil:
    section.add "prettyPrint", valid_578933
  var valid_578934 = query.getOrDefault("oauth_token")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "oauth_token", valid_578934
  var valid_578935 = query.getOrDefault("$.xgafv")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = newJString("1"))
  if valid_578935 != nil:
    section.add "$.xgafv", valid_578935
  var valid_578936 = query.getOrDefault("alt")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("json"))
  if valid_578936 != nil:
    section.add "alt", valid_578936
  var valid_578937 = query.getOrDefault("uploadType")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "uploadType", valid_578937
  var valid_578938 = query.getOrDefault("quotaUser")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "quotaUser", valid_578938
  var valid_578939 = query.getOrDefault("updateMask")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "updateMask", valid_578939
  var valid_578940 = query.getOrDefault("intentView")
  valid_578940 = validateParameter(valid_578940, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_578940 != nil:
    section.add "intentView", valid_578940
  var valid_578941 = query.getOrDefault("callback")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "callback", valid_578941
  var valid_578942 = query.getOrDefault("languageCode")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "languageCode", valid_578942
  var valid_578943 = query.getOrDefault("fields")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "fields", valid_578943
  var valid_578944 = query.getOrDefault("access_token")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "access_token", valid_578944
  var valid_578945 = query.getOrDefault("upload_protocol")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "upload_protocol", valid_578945
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

proc call*(call_578947: Call_DialogflowProjectsAgentIntentsPatch_578928;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the specified intent.
  ## 
  let valid = call_578947.validator(path, query, header, formData, body)
  let scheme = call_578947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578947.url(scheme.get, call_578947.host, call_578947.base,
                         call_578947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578947, url, valid)

proc call*(call_578948: Call_DialogflowProjectsAgentIntentsPatch_578928;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          intentView: string = "INTENT_VIEW_UNSPECIFIED"; body: JsonNode = nil;
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsPatch
  ## Updates the specified intent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The unique identifier of this intent.
  ## Required for Intents.UpdateIntent and Intents.BatchUpdateIntents
  ## methods.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
  ##   updateMask: string
  ##             : Optional. The mask to control which fields get updated.
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   languageCode: string
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578949 = newJObject()
  var query_578950 = newJObject()
  var body_578951 = newJObject()
  add(query_578950, "key", newJString(key))
  add(query_578950, "prettyPrint", newJBool(prettyPrint))
  add(query_578950, "oauth_token", newJString(oauthToken))
  add(query_578950, "$.xgafv", newJString(Xgafv))
  add(query_578950, "alt", newJString(alt))
  add(query_578950, "uploadType", newJString(uploadType))
  add(query_578950, "quotaUser", newJString(quotaUser))
  add(path_578949, "name", newJString(name))
  add(query_578950, "updateMask", newJString(updateMask))
  add(query_578950, "intentView", newJString(intentView))
  if body != nil:
    body_578951 = body
  add(query_578950, "callback", newJString(callback))
  add(query_578950, "languageCode", newJString(languageCode))
  add(query_578950, "fields", newJString(fields))
  add(query_578950, "access_token", newJString(accessToken))
  add(query_578950, "upload_protocol", newJString(uploadProtocol))
  result = call_578948.call(path_578949, query_578950, nil, nil, body_578951)

var dialogflowProjectsAgentIntentsPatch* = Call_DialogflowProjectsAgentIntentsPatch_578928(
    name: "dialogflowProjectsAgentIntentsPatch", meth: HttpMethod.HttpPatch,
    host: "dialogflow.googleapis.com", route: "/v2/{name}",
    validator: validate_DialogflowProjectsAgentIntentsPatch_578929, base: "/",
    url: url_DialogflowProjectsAgentIntentsPatch_578930, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsDelete_578909 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentIntentsDelete_578911(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsDelete_578910(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified intent and its direct or indirect followup intents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the intent to delete. If this intent has direct or
  ## indirect followup intents, we also delete them.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578912 = path.getOrDefault("name")
  valid_578912 = validateParameter(valid_578912, JString, required = true,
                                 default = nil)
  if valid_578912 != nil:
    section.add "name", valid_578912
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578913 = query.getOrDefault("key")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "key", valid_578913
  var valid_578914 = query.getOrDefault("prettyPrint")
  valid_578914 = validateParameter(valid_578914, JBool, required = false,
                                 default = newJBool(true))
  if valid_578914 != nil:
    section.add "prettyPrint", valid_578914
  var valid_578915 = query.getOrDefault("oauth_token")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "oauth_token", valid_578915
  var valid_578916 = query.getOrDefault("$.xgafv")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("1"))
  if valid_578916 != nil:
    section.add "$.xgafv", valid_578916
  var valid_578917 = query.getOrDefault("alt")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = newJString("json"))
  if valid_578917 != nil:
    section.add "alt", valid_578917
  var valid_578918 = query.getOrDefault("uploadType")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "uploadType", valid_578918
  var valid_578919 = query.getOrDefault("quotaUser")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "quotaUser", valid_578919
  var valid_578920 = query.getOrDefault("callback")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "callback", valid_578920
  var valid_578921 = query.getOrDefault("fields")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "fields", valid_578921
  var valid_578922 = query.getOrDefault("access_token")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "access_token", valid_578922
  var valid_578923 = query.getOrDefault("upload_protocol")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "upload_protocol", valid_578923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578924: Call_DialogflowProjectsAgentIntentsDelete_578909;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the specified intent and its direct or indirect followup intents.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_DialogflowProjectsAgentIntentsDelete_578909;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsDelete
  ## Deletes the specified intent and its direct or indirect followup intents.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the intent to delete. If this intent has direct or
  ## indirect followup intents, we also delete them.
  ## Format: `projects/<Project ID>/agent/intents/<Intent ID>`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "$.xgafv", newJString(Xgafv))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "uploadType", newJString(uploadType))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(path_578926, "name", newJString(name))
  add(query_578927, "callback", newJString(callback))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "access_token", newJString(accessToken))
  add(query_578927, "upload_protocol", newJString(uploadProtocol))
  result = call_578925.call(path_578926, query_578927, nil, nil, nil)

var dialogflowProjectsAgentIntentsDelete* = Call_DialogflowProjectsAgentIntentsDelete_578909(
    name: "dialogflowProjectsAgentIntentsDelete", meth: HttpMethod.HttpDelete,
    host: "dialogflow.googleapis.com", route: "/v2/{name}",
    validator: validate_DialogflowProjectsAgentIntentsDelete_578910, base: "/",
    url: url_DialogflowProjectsAgentIntentsDelete_578911, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsLocationsOperationsList_578952 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsLocationsOperationsList_578954(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsLocationsOperationsList_578953(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578955 = path.getOrDefault("name")
  valid_578955 = validateParameter(valid_578955, JString, required = true,
                                 default = nil)
  if valid_578955 != nil:
    section.add "name", valid_578955
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578956 = query.getOrDefault("key")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "key", valid_578956
  var valid_578957 = query.getOrDefault("prettyPrint")
  valid_578957 = validateParameter(valid_578957, JBool, required = false,
                                 default = newJBool(true))
  if valid_578957 != nil:
    section.add "prettyPrint", valid_578957
  var valid_578958 = query.getOrDefault("oauth_token")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "oauth_token", valid_578958
  var valid_578959 = query.getOrDefault("$.xgafv")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = newJString("1"))
  if valid_578959 != nil:
    section.add "$.xgafv", valid_578959
  var valid_578960 = query.getOrDefault("pageSize")
  valid_578960 = validateParameter(valid_578960, JInt, required = false, default = nil)
  if valid_578960 != nil:
    section.add "pageSize", valid_578960
  var valid_578961 = query.getOrDefault("alt")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = newJString("json"))
  if valid_578961 != nil:
    section.add "alt", valid_578961
  var valid_578962 = query.getOrDefault("uploadType")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "uploadType", valid_578962
  var valid_578963 = query.getOrDefault("quotaUser")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "quotaUser", valid_578963
  var valid_578964 = query.getOrDefault("filter")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "filter", valid_578964
  var valid_578965 = query.getOrDefault("pageToken")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "pageToken", valid_578965
  var valid_578966 = query.getOrDefault("callback")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "callback", valid_578966
  var valid_578967 = query.getOrDefault("fields")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "fields", valid_578967
  var valid_578968 = query.getOrDefault("access_token")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "access_token", valid_578968
  var valid_578969 = query.getOrDefault("upload_protocol")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "upload_protocol", valid_578969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578970: Call_DialogflowProjectsLocationsOperationsList_578952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_578970.validator(path, query, header, formData, body)
  let scheme = call_578970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578970.url(scheme.get, call_578970.host, call_578970.base,
                         call_578970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578970, url, valid)

proc call*(call_578971: Call_DialogflowProjectsLocationsOperationsList_578952;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsLocationsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578972 = newJObject()
  var query_578973 = newJObject()
  add(query_578973, "key", newJString(key))
  add(query_578973, "prettyPrint", newJBool(prettyPrint))
  add(query_578973, "oauth_token", newJString(oauthToken))
  add(query_578973, "$.xgafv", newJString(Xgafv))
  add(query_578973, "pageSize", newJInt(pageSize))
  add(query_578973, "alt", newJString(alt))
  add(query_578973, "uploadType", newJString(uploadType))
  add(query_578973, "quotaUser", newJString(quotaUser))
  add(path_578972, "name", newJString(name))
  add(query_578973, "filter", newJString(filter))
  add(query_578973, "pageToken", newJString(pageToken))
  add(query_578973, "callback", newJString(callback))
  add(query_578973, "fields", newJString(fields))
  add(query_578973, "access_token", newJString(accessToken))
  add(query_578973, "upload_protocol", newJString(uploadProtocol))
  result = call_578971.call(path_578972, query_578973, nil, nil, nil)

var dialogflowProjectsLocationsOperationsList* = Call_DialogflowProjectsLocationsOperationsList_578952(
    name: "dialogflowProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{name}/operations",
    validator: validate_DialogflowProjectsLocationsOperationsList_578953,
    base: "/", url: url_DialogflowProjectsLocationsOperationsList_578954,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsLocationsOperationsCancel_578974 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsLocationsOperationsCancel_578976(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsLocationsOperationsCancel_578975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578977 = path.getOrDefault("name")
  valid_578977 = validateParameter(valid_578977, JString, required = true,
                                 default = nil)
  if valid_578977 != nil:
    section.add "name", valid_578977
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578978 = query.getOrDefault("key")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "key", valid_578978
  var valid_578979 = query.getOrDefault("prettyPrint")
  valid_578979 = validateParameter(valid_578979, JBool, required = false,
                                 default = newJBool(true))
  if valid_578979 != nil:
    section.add "prettyPrint", valid_578979
  var valid_578980 = query.getOrDefault("oauth_token")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "oauth_token", valid_578980
  var valid_578981 = query.getOrDefault("$.xgafv")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("1"))
  if valid_578981 != nil:
    section.add "$.xgafv", valid_578981
  var valid_578982 = query.getOrDefault("alt")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = newJString("json"))
  if valid_578982 != nil:
    section.add "alt", valid_578982
  var valid_578983 = query.getOrDefault("uploadType")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "uploadType", valid_578983
  var valid_578984 = query.getOrDefault("quotaUser")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "quotaUser", valid_578984
  var valid_578985 = query.getOrDefault("callback")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "callback", valid_578985
  var valid_578986 = query.getOrDefault("fields")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "fields", valid_578986
  var valid_578987 = query.getOrDefault("access_token")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "access_token", valid_578987
  var valid_578988 = query.getOrDefault("upload_protocol")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "upload_protocol", valid_578988
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578989: Call_DialogflowProjectsLocationsOperationsCancel_578974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_DialogflowProjectsLocationsOperationsCancel_578974;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsLocationsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578991 = newJObject()
  var query_578992 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "$.xgafv", newJString(Xgafv))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "uploadType", newJString(uploadType))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "name", newJString(name))
  add(query_578992, "callback", newJString(callback))
  add(query_578992, "fields", newJString(fields))
  add(query_578992, "access_token", newJString(accessToken))
  add(query_578992, "upload_protocol", newJString(uploadProtocol))
  result = call_578990.call(path_578991, query_578992, nil, nil, nil)

var dialogflowProjectsLocationsOperationsCancel* = Call_DialogflowProjectsLocationsOperationsCancel_578974(
    name: "dialogflowProjectsLocationsOperationsCancel",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{name}:cancel",
    validator: validate_DialogflowProjectsLocationsOperationsCancel_578975,
    base: "/", url: url_DialogflowProjectsLocationsOperationsCancel_578976,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgent_579012 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgent_579014(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgent_579013(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates/updates the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project of this agent.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579015 = path.getOrDefault("parent")
  valid_579015 = validateParameter(valid_579015, JString, required = true,
                                 default = nil)
  if valid_579015 != nil:
    section.add "parent", valid_579015
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: JString
  ##             : Optional. The mask to control which fields get updated.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579016 = query.getOrDefault("key")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "key", valid_579016
  var valid_579017 = query.getOrDefault("prettyPrint")
  valid_579017 = validateParameter(valid_579017, JBool, required = false,
                                 default = newJBool(true))
  if valid_579017 != nil:
    section.add "prettyPrint", valid_579017
  var valid_579018 = query.getOrDefault("oauth_token")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = nil)
  if valid_579018 != nil:
    section.add "oauth_token", valid_579018
  var valid_579019 = query.getOrDefault("$.xgafv")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("1"))
  if valid_579019 != nil:
    section.add "$.xgafv", valid_579019
  var valid_579020 = query.getOrDefault("alt")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("json"))
  if valid_579020 != nil:
    section.add "alt", valid_579020
  var valid_579021 = query.getOrDefault("uploadType")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "uploadType", valid_579021
  var valid_579022 = query.getOrDefault("quotaUser")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "quotaUser", valid_579022
  var valid_579023 = query.getOrDefault("updateMask")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "updateMask", valid_579023
  var valid_579024 = query.getOrDefault("callback")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "callback", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  var valid_579026 = query.getOrDefault("access_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "access_token", valid_579026
  var valid_579027 = query.getOrDefault("upload_protocol")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "upload_protocol", valid_579027
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

proc call*(call_579029: Call_DialogflowProjectsAgent_579012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates/updates the specified agent.
  ## 
  let valid = call_579029.validator(path, query, header, formData, body)
  let scheme = call_579029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579029.url(scheme.get, call_579029.host, call_579029.base,
                         call_579029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579029, url, valid)

proc call*(call_579030: Call_DialogflowProjectsAgent_579012; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; updateMask: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgent
  ## Creates/updates the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   updateMask: string
  ##             : Optional. The mask to control which fields get updated.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project of this agent.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579031 = newJObject()
  var query_579032 = newJObject()
  var body_579033 = newJObject()
  add(query_579032, "key", newJString(key))
  add(query_579032, "prettyPrint", newJBool(prettyPrint))
  add(query_579032, "oauth_token", newJString(oauthToken))
  add(query_579032, "$.xgafv", newJString(Xgafv))
  add(query_579032, "alt", newJString(alt))
  add(query_579032, "uploadType", newJString(uploadType))
  add(query_579032, "quotaUser", newJString(quotaUser))
  add(query_579032, "updateMask", newJString(updateMask))
  if body != nil:
    body_579033 = body
  add(query_579032, "callback", newJString(callback))
  add(path_579031, "parent", newJString(parent))
  add(query_579032, "fields", newJString(fields))
  add(query_579032, "access_token", newJString(accessToken))
  add(query_579032, "upload_protocol", newJString(uploadProtocol))
  result = call_579030.call(path_579031, query_579032, nil, nil, body_579033)

var dialogflowProjectsAgent* = Call_DialogflowProjectsAgent_579012(
    name: "dialogflowProjectsAgent", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent",
    validator: validate_DialogflowProjectsAgent_579013, base: "/",
    url: url_DialogflowProjectsAgent_579014, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsGetAgent_578993 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsGetAgent_578995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsGetAgent_578994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to fetch is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_578996 = path.getOrDefault("parent")
  valid_578996 = validateParameter(valid_578996, JString, required = true,
                                 default = nil)
  if valid_578996 != nil:
    section.add "parent", valid_578996
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578997 = query.getOrDefault("key")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "key", valid_578997
  var valid_578998 = query.getOrDefault("prettyPrint")
  valid_578998 = validateParameter(valid_578998, JBool, required = false,
                                 default = newJBool(true))
  if valid_578998 != nil:
    section.add "prettyPrint", valid_578998
  var valid_578999 = query.getOrDefault("oauth_token")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "oauth_token", valid_578999
  var valid_579000 = query.getOrDefault("$.xgafv")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = newJString("1"))
  if valid_579000 != nil:
    section.add "$.xgafv", valid_579000
  var valid_579001 = query.getOrDefault("alt")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("json"))
  if valid_579001 != nil:
    section.add "alt", valid_579001
  var valid_579002 = query.getOrDefault("uploadType")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "uploadType", valid_579002
  var valid_579003 = query.getOrDefault("quotaUser")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "quotaUser", valid_579003
  var valid_579004 = query.getOrDefault("callback")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "callback", valid_579004
  var valid_579005 = query.getOrDefault("fields")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "fields", valid_579005
  var valid_579006 = query.getOrDefault("access_token")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "access_token", valid_579006
  var valid_579007 = query.getOrDefault("upload_protocol")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "upload_protocol", valid_579007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579008: Call_DialogflowProjectsGetAgent_578993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the specified agent.
  ## 
  let valid = call_579008.validator(path, query, header, formData, body)
  let scheme = call_579008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579008.url(scheme.get, call_579008.host, call_579008.base,
                         call_579008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579008, url, valid)

proc call*(call_579009: Call_DialogflowProjectsGetAgent_578993; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsGetAgent
  ## Retrieves the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project that the agent to fetch is associated with.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579010 = newJObject()
  var query_579011 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "$.xgafv", newJString(Xgafv))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "uploadType", newJString(uploadType))
  add(query_579011, "quotaUser", newJString(quotaUser))
  add(query_579011, "callback", newJString(callback))
  add(path_579010, "parent", newJString(parent))
  add(query_579011, "fields", newJString(fields))
  add(query_579011, "access_token", newJString(accessToken))
  add(query_579011, "upload_protocol", newJString(uploadProtocol))
  result = call_579009.call(path_579010, query_579011, nil, nil, nil)

var dialogflowProjectsGetAgent* = Call_DialogflowProjectsGetAgent_578993(
    name: "dialogflowProjectsGetAgent", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent",
    validator: validate_DialogflowProjectsGetAgent_578994, base: "/",
    url: url_DialogflowProjectsGetAgent_578995, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsDeleteAgent_579034 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsDeleteAgent_579036(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsDeleteAgent_579035(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to delete is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579037 = path.getOrDefault("parent")
  valid_579037 = validateParameter(valid_579037, JString, required = true,
                                 default = nil)
  if valid_579037 != nil:
    section.add "parent", valid_579037
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579038 = query.getOrDefault("key")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "key", valid_579038
  var valid_579039 = query.getOrDefault("prettyPrint")
  valid_579039 = validateParameter(valid_579039, JBool, required = false,
                                 default = newJBool(true))
  if valid_579039 != nil:
    section.add "prettyPrint", valid_579039
  var valid_579040 = query.getOrDefault("oauth_token")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "oauth_token", valid_579040
  var valid_579041 = query.getOrDefault("$.xgafv")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = newJString("1"))
  if valid_579041 != nil:
    section.add "$.xgafv", valid_579041
  var valid_579042 = query.getOrDefault("alt")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("json"))
  if valid_579042 != nil:
    section.add "alt", valid_579042
  var valid_579043 = query.getOrDefault("uploadType")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "uploadType", valid_579043
  var valid_579044 = query.getOrDefault("quotaUser")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "quotaUser", valid_579044
  var valid_579045 = query.getOrDefault("callback")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "callback", valid_579045
  var valid_579046 = query.getOrDefault("fields")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "fields", valid_579046
  var valid_579047 = query.getOrDefault("access_token")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "access_token", valid_579047
  var valid_579048 = query.getOrDefault("upload_protocol")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "upload_protocol", valid_579048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579049: Call_DialogflowProjectsDeleteAgent_579034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified agent.
  ## 
  let valid = call_579049.validator(path, query, header, formData, body)
  let scheme = call_579049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579049.url(scheme.get, call_579049.host, call_579049.base,
                         call_579049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579049, url, valid)

proc call*(call_579050: Call_DialogflowProjectsDeleteAgent_579034; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsDeleteAgent
  ## Deletes the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project that the agent to delete is associated with.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579051 = newJObject()
  var query_579052 = newJObject()
  add(query_579052, "key", newJString(key))
  add(query_579052, "prettyPrint", newJBool(prettyPrint))
  add(query_579052, "oauth_token", newJString(oauthToken))
  add(query_579052, "$.xgafv", newJString(Xgafv))
  add(query_579052, "alt", newJString(alt))
  add(query_579052, "uploadType", newJString(uploadType))
  add(query_579052, "quotaUser", newJString(quotaUser))
  add(query_579052, "callback", newJString(callback))
  add(path_579051, "parent", newJString(parent))
  add(query_579052, "fields", newJString(fields))
  add(query_579052, "access_token", newJString(accessToken))
  add(query_579052, "upload_protocol", newJString(uploadProtocol))
  result = call_579050.call(path_579051, query_579052, nil, nil, nil)

var dialogflowProjectsDeleteAgent* = Call_DialogflowProjectsDeleteAgent_579034(
    name: "dialogflowProjectsDeleteAgent", meth: HttpMethod.HttpDelete,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent",
    validator: validate_DialogflowProjectsDeleteAgent_579035, base: "/",
    url: url_DialogflowProjectsDeleteAgent_579036, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentExport_579053 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentExport_579055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentExport_579054(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the specified agent to a ZIP file.
  ## 
  ## Operation <response: ExportAgentResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to export is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579056 = path.getOrDefault("parent")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "parent", valid_579056
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579057 = query.getOrDefault("key")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = nil)
  if valid_579057 != nil:
    section.add "key", valid_579057
  var valid_579058 = query.getOrDefault("prettyPrint")
  valid_579058 = validateParameter(valid_579058, JBool, required = false,
                                 default = newJBool(true))
  if valid_579058 != nil:
    section.add "prettyPrint", valid_579058
  var valid_579059 = query.getOrDefault("oauth_token")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "oauth_token", valid_579059
  var valid_579060 = query.getOrDefault("$.xgafv")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = newJString("1"))
  if valid_579060 != nil:
    section.add "$.xgafv", valid_579060
  var valid_579061 = query.getOrDefault("alt")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("json"))
  if valid_579061 != nil:
    section.add "alt", valid_579061
  var valid_579062 = query.getOrDefault("uploadType")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "uploadType", valid_579062
  var valid_579063 = query.getOrDefault("quotaUser")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "quotaUser", valid_579063
  var valid_579064 = query.getOrDefault("callback")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "callback", valid_579064
  var valid_579065 = query.getOrDefault("fields")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "fields", valid_579065
  var valid_579066 = query.getOrDefault("access_token")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "access_token", valid_579066
  var valid_579067 = query.getOrDefault("upload_protocol")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "upload_protocol", valid_579067
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

proc call*(call_579069: Call_DialogflowProjectsAgentExport_579053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the specified agent to a ZIP file.
  ## 
  ## Operation <response: ExportAgentResponse>
  ## 
  let valid = call_579069.validator(path, query, header, formData, body)
  let scheme = call_579069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579069.url(scheme.get, call_579069.host, call_579069.base,
                         call_579069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579069, url, valid)

proc call*(call_579070: Call_DialogflowProjectsAgentExport_579053; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentExport
  ## Exports the specified agent to a ZIP file.
  ## 
  ## Operation <response: ExportAgentResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project that the agent to export is associated with.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579071 = newJObject()
  var query_579072 = newJObject()
  var body_579073 = newJObject()
  add(query_579072, "key", newJString(key))
  add(query_579072, "prettyPrint", newJBool(prettyPrint))
  add(query_579072, "oauth_token", newJString(oauthToken))
  add(query_579072, "$.xgafv", newJString(Xgafv))
  add(query_579072, "alt", newJString(alt))
  add(query_579072, "uploadType", newJString(uploadType))
  add(query_579072, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579073 = body
  add(query_579072, "callback", newJString(callback))
  add(path_579071, "parent", newJString(parent))
  add(query_579072, "fields", newJString(fields))
  add(query_579072, "access_token", newJString(accessToken))
  add(query_579072, "upload_protocol", newJString(uploadProtocol))
  result = call_579070.call(path_579071, query_579072, nil, nil, body_579073)

var dialogflowProjectsAgentExport* = Call_DialogflowProjectsAgentExport_579053(
    name: "dialogflowProjectsAgentExport", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:export",
    validator: validate_DialogflowProjectsAgentExport_579054, base: "/",
    url: url_DialogflowProjectsAgentExport_579055, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentImport_579074 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentImport_579076(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentImport_579075(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports the specified agent from a ZIP file.
  ## 
  ## Uploads new intents and entity types without deleting the existing ones.
  ## Intents and entity types with the same name are replaced with the new
  ## versions from ImportAgentRequest.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to import is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579077 = path.getOrDefault("parent")
  valid_579077 = validateParameter(valid_579077, JString, required = true,
                                 default = nil)
  if valid_579077 != nil:
    section.add "parent", valid_579077
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579078 = query.getOrDefault("key")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = nil)
  if valid_579078 != nil:
    section.add "key", valid_579078
  var valid_579079 = query.getOrDefault("prettyPrint")
  valid_579079 = validateParameter(valid_579079, JBool, required = false,
                                 default = newJBool(true))
  if valid_579079 != nil:
    section.add "prettyPrint", valid_579079
  var valid_579080 = query.getOrDefault("oauth_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "oauth_token", valid_579080
  var valid_579081 = query.getOrDefault("$.xgafv")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = newJString("1"))
  if valid_579081 != nil:
    section.add "$.xgafv", valid_579081
  var valid_579082 = query.getOrDefault("alt")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = newJString("json"))
  if valid_579082 != nil:
    section.add "alt", valid_579082
  var valid_579083 = query.getOrDefault("uploadType")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "uploadType", valid_579083
  var valid_579084 = query.getOrDefault("quotaUser")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "quotaUser", valid_579084
  var valid_579085 = query.getOrDefault("callback")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = nil)
  if valid_579085 != nil:
    section.add "callback", valid_579085
  var valid_579086 = query.getOrDefault("fields")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "fields", valid_579086
  var valid_579087 = query.getOrDefault("access_token")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "access_token", valid_579087
  var valid_579088 = query.getOrDefault("upload_protocol")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "upload_protocol", valid_579088
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

proc call*(call_579090: Call_DialogflowProjectsAgentImport_579074; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports the specified agent from a ZIP file.
  ## 
  ## Uploads new intents and entity types without deleting the existing ones.
  ## Intents and entity types with the same name are replaced with the new
  ## versions from ImportAgentRequest.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579090.validator(path, query, header, formData, body)
  let scheme = call_579090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579090.url(scheme.get, call_579090.host, call_579090.base,
                         call_579090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579090, url, valid)

proc call*(call_579091: Call_DialogflowProjectsAgentImport_579074; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentImport
  ## Imports the specified agent from a ZIP file.
  ## 
  ## Uploads new intents and entity types without deleting the existing ones.
  ## Intents and entity types with the same name are replaced with the new
  ## versions from ImportAgentRequest.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project that the agent to import is associated with.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579092 = newJObject()
  var query_579093 = newJObject()
  var body_579094 = newJObject()
  add(query_579093, "key", newJString(key))
  add(query_579093, "prettyPrint", newJBool(prettyPrint))
  add(query_579093, "oauth_token", newJString(oauthToken))
  add(query_579093, "$.xgafv", newJString(Xgafv))
  add(query_579093, "alt", newJString(alt))
  add(query_579093, "uploadType", newJString(uploadType))
  add(query_579093, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579094 = body
  add(query_579093, "callback", newJString(callback))
  add(path_579092, "parent", newJString(parent))
  add(query_579093, "fields", newJString(fields))
  add(query_579093, "access_token", newJString(accessToken))
  add(query_579093, "upload_protocol", newJString(uploadProtocol))
  result = call_579091.call(path_579092, query_579093, nil, nil, body_579094)

var dialogflowProjectsAgentImport* = Call_DialogflowProjectsAgentImport_579074(
    name: "dialogflowProjectsAgentImport", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:import",
    validator: validate_DialogflowProjectsAgentImport_579075, base: "/",
    url: url_DialogflowProjectsAgentImport_579076, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentRestore_579095 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentRestore_579097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:restore")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentRestore_579096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restores the specified agent from a ZIP file.
  ## 
  ## Replaces the current agent version with a new one. All the intents and
  ## entity types in the older version are deleted.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to restore is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579098 = path.getOrDefault("parent")
  valid_579098 = validateParameter(valid_579098, JString, required = true,
                                 default = nil)
  if valid_579098 != nil:
    section.add "parent", valid_579098
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579099 = query.getOrDefault("key")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "key", valid_579099
  var valid_579100 = query.getOrDefault("prettyPrint")
  valid_579100 = validateParameter(valid_579100, JBool, required = false,
                                 default = newJBool(true))
  if valid_579100 != nil:
    section.add "prettyPrint", valid_579100
  var valid_579101 = query.getOrDefault("oauth_token")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "oauth_token", valid_579101
  var valid_579102 = query.getOrDefault("$.xgafv")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = newJString("1"))
  if valid_579102 != nil:
    section.add "$.xgafv", valid_579102
  var valid_579103 = query.getOrDefault("alt")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = newJString("json"))
  if valid_579103 != nil:
    section.add "alt", valid_579103
  var valid_579104 = query.getOrDefault("uploadType")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "uploadType", valid_579104
  var valid_579105 = query.getOrDefault("quotaUser")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "quotaUser", valid_579105
  var valid_579106 = query.getOrDefault("callback")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = nil)
  if valid_579106 != nil:
    section.add "callback", valid_579106
  var valid_579107 = query.getOrDefault("fields")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "fields", valid_579107
  var valid_579108 = query.getOrDefault("access_token")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "access_token", valid_579108
  var valid_579109 = query.getOrDefault("upload_protocol")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "upload_protocol", valid_579109
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

proc call*(call_579111: Call_DialogflowProjectsAgentRestore_579095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restores the specified agent from a ZIP file.
  ## 
  ## Replaces the current agent version with a new one. All the intents and
  ## entity types in the older version are deleted.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579111.validator(path, query, header, formData, body)
  let scheme = call_579111.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579111.url(scheme.get, call_579111.host, call_579111.base,
                         call_579111.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579111, url, valid)

proc call*(call_579112: Call_DialogflowProjectsAgentRestore_579095; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentRestore
  ## Restores the specified agent from a ZIP file.
  ## 
  ## Replaces the current agent version with a new one. All the intents and
  ## entity types in the older version are deleted.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project that the agent to restore is associated with.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579113 = newJObject()
  var query_579114 = newJObject()
  var body_579115 = newJObject()
  add(query_579114, "key", newJString(key))
  add(query_579114, "prettyPrint", newJBool(prettyPrint))
  add(query_579114, "oauth_token", newJString(oauthToken))
  add(query_579114, "$.xgafv", newJString(Xgafv))
  add(query_579114, "alt", newJString(alt))
  add(query_579114, "uploadType", newJString(uploadType))
  add(query_579114, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579115 = body
  add(query_579114, "callback", newJString(callback))
  add(path_579113, "parent", newJString(parent))
  add(query_579114, "fields", newJString(fields))
  add(query_579114, "access_token", newJString(accessToken))
  add(query_579114, "upload_protocol", newJString(uploadProtocol))
  result = call_579112.call(path_579113, query_579114, nil, nil, body_579115)

var dialogflowProjectsAgentRestore* = Call_DialogflowProjectsAgentRestore_579095(
    name: "dialogflowProjectsAgentRestore", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:restore",
    validator: validate_DialogflowProjectsAgentRestore_579096, base: "/",
    url: url_DialogflowProjectsAgentRestore_579097, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSearch_579116 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentSearch_579118(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:search")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSearch_579117(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of agents.
  ## 
  ## Since there is at most one conversational agent per project, this method is
  ## useful primarily for listing all agents across projects the caller has
  ## access to. One can achieve that with a wildcard project collection id "-".
  ## Refer to [List
  ## Sub-Collections](https://cloud.google.com/apis/design/design_patterns#list_sub-collections).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project to list agents from.
  ## Format: `projects/<Project ID or '-'>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579119 = path.getOrDefault("parent")
  valid_579119 = validateParameter(valid_579119, JString, required = true,
                                 default = nil)
  if valid_579119 != nil:
    section.add "parent", valid_579119
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous list request.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579120 = query.getOrDefault("key")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "key", valid_579120
  var valid_579121 = query.getOrDefault("prettyPrint")
  valid_579121 = validateParameter(valid_579121, JBool, required = false,
                                 default = newJBool(true))
  if valid_579121 != nil:
    section.add "prettyPrint", valid_579121
  var valid_579122 = query.getOrDefault("oauth_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "oauth_token", valid_579122
  var valid_579123 = query.getOrDefault("$.xgafv")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = newJString("1"))
  if valid_579123 != nil:
    section.add "$.xgafv", valid_579123
  var valid_579124 = query.getOrDefault("pageSize")
  valid_579124 = validateParameter(valid_579124, JInt, required = false, default = nil)
  if valid_579124 != nil:
    section.add "pageSize", valid_579124
  var valid_579125 = query.getOrDefault("alt")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = newJString("json"))
  if valid_579125 != nil:
    section.add "alt", valid_579125
  var valid_579126 = query.getOrDefault("uploadType")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = nil)
  if valid_579126 != nil:
    section.add "uploadType", valid_579126
  var valid_579127 = query.getOrDefault("quotaUser")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "quotaUser", valid_579127
  var valid_579128 = query.getOrDefault("pageToken")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = nil)
  if valid_579128 != nil:
    section.add "pageToken", valid_579128
  var valid_579129 = query.getOrDefault("callback")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "callback", valid_579129
  var valid_579130 = query.getOrDefault("fields")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "fields", valid_579130
  var valid_579131 = query.getOrDefault("access_token")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "access_token", valid_579131
  var valid_579132 = query.getOrDefault("upload_protocol")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "upload_protocol", valid_579132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579133: Call_DialogflowProjectsAgentSearch_579116; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of agents.
  ## 
  ## Since there is at most one conversational agent per project, this method is
  ## useful primarily for listing all agents across projects the caller has
  ## access to. One can achieve that with a wildcard project collection id "-".
  ## Refer to [List
  ## Sub-Collections](https://cloud.google.com/apis/design/design_patterns#list_sub-collections).
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_DialogflowProjectsAgentSearch_579116; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentSearch
  ## Returns the list of agents.
  ## 
  ## Since there is at most one conversational agent per project, this method is
  ## useful primarily for listing all agents across projects the caller has
  ## access to. One can achieve that with a wildcard project collection id "-".
  ## Refer to [List
  ## Sub-Collections](https://cloud.google.com/apis/design/design_patterns#list_sub-collections).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous list request.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project to list agents from.
  ## Format: `projects/<Project ID or '-'>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "$.xgafv", newJString(Xgafv))
  add(query_579136, "pageSize", newJInt(pageSize))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "uploadType", newJString(uploadType))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(query_579136, "pageToken", newJString(pageToken))
  add(query_579136, "callback", newJString(callback))
  add(path_579135, "parent", newJString(parent))
  add(query_579136, "fields", newJString(fields))
  add(query_579136, "access_token", newJString(accessToken))
  add(query_579136, "upload_protocol", newJString(uploadProtocol))
  result = call_579134.call(path_579135, query_579136, nil, nil, nil)

var dialogflowProjectsAgentSearch* = Call_DialogflowProjectsAgentSearch_579116(
    name: "dialogflowProjectsAgentSearch", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:search",
    validator: validate_DialogflowProjectsAgentSearch_579117, base: "/",
    url: url_DialogflowProjectsAgentSearch_579118, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentTrain_579137 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentTrain_579139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/agent:train")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentTrain_579138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Trains the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project that the agent to train is associated with.
  ## Format: `projects/<Project ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579140 = path.getOrDefault("parent")
  valid_579140 = validateParameter(valid_579140, JString, required = true,
                                 default = nil)
  if valid_579140 != nil:
    section.add "parent", valid_579140
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579141 = query.getOrDefault("key")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "key", valid_579141
  var valid_579142 = query.getOrDefault("prettyPrint")
  valid_579142 = validateParameter(valid_579142, JBool, required = false,
                                 default = newJBool(true))
  if valid_579142 != nil:
    section.add "prettyPrint", valid_579142
  var valid_579143 = query.getOrDefault("oauth_token")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "oauth_token", valid_579143
  var valid_579144 = query.getOrDefault("$.xgafv")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = newJString("1"))
  if valid_579144 != nil:
    section.add "$.xgafv", valid_579144
  var valid_579145 = query.getOrDefault("alt")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = newJString("json"))
  if valid_579145 != nil:
    section.add "alt", valid_579145
  var valid_579146 = query.getOrDefault("uploadType")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "uploadType", valid_579146
  var valid_579147 = query.getOrDefault("quotaUser")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "quotaUser", valid_579147
  var valid_579148 = query.getOrDefault("callback")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "callback", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  var valid_579150 = query.getOrDefault("access_token")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "access_token", valid_579150
  var valid_579151 = query.getOrDefault("upload_protocol")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "upload_protocol", valid_579151
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

proc call*(call_579153: Call_DialogflowProjectsAgentTrain_579137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Trains the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579153.validator(path, query, header, formData, body)
  let scheme = call_579153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579153.url(scheme.get, call_579153.host, call_579153.base,
                         call_579153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579153, url, valid)

proc call*(call_579154: Call_DialogflowProjectsAgentTrain_579137; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentTrain
  ## Trains the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The project that the agent to train is associated with.
  ## Format: `projects/<Project ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579155 = newJObject()
  var query_579156 = newJObject()
  var body_579157 = newJObject()
  add(query_579156, "key", newJString(key))
  add(query_579156, "prettyPrint", newJBool(prettyPrint))
  add(query_579156, "oauth_token", newJString(oauthToken))
  add(query_579156, "$.xgafv", newJString(Xgafv))
  add(query_579156, "alt", newJString(alt))
  add(query_579156, "uploadType", newJString(uploadType))
  add(query_579156, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579157 = body
  add(query_579156, "callback", newJString(callback))
  add(path_579155, "parent", newJString(parent))
  add(query_579156, "fields", newJString(fields))
  add(query_579156, "access_token", newJString(accessToken))
  add(query_579156, "upload_protocol", newJString(uploadProtocol))
  result = call_579154.call(path_579155, query_579156, nil, nil, body_579157)

var dialogflowProjectsAgentTrain* = Call_DialogflowProjectsAgentTrain_579137(
    name: "dialogflowProjectsAgentTrain", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/agent:train",
    validator: validate_DialogflowProjectsAgentTrain_579138, base: "/",
    url: url_DialogflowProjectsAgentTrain_579139, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsContextsCreate_579179 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentSessionsContextsCreate_579181(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/contexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsContextsCreate_579180(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a context.
  ## 
  ## If the specified context already exists, overrides the context.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The session to create a context for.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579182 = path.getOrDefault("parent")
  valid_579182 = validateParameter(valid_579182, JString, required = true,
                                 default = nil)
  if valid_579182 != nil:
    section.add "parent", valid_579182
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579183 = query.getOrDefault("key")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "key", valid_579183
  var valid_579184 = query.getOrDefault("prettyPrint")
  valid_579184 = validateParameter(valid_579184, JBool, required = false,
                                 default = newJBool(true))
  if valid_579184 != nil:
    section.add "prettyPrint", valid_579184
  var valid_579185 = query.getOrDefault("oauth_token")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "oauth_token", valid_579185
  var valid_579186 = query.getOrDefault("$.xgafv")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = newJString("1"))
  if valid_579186 != nil:
    section.add "$.xgafv", valid_579186
  var valid_579187 = query.getOrDefault("alt")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = newJString("json"))
  if valid_579187 != nil:
    section.add "alt", valid_579187
  var valid_579188 = query.getOrDefault("uploadType")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "uploadType", valid_579188
  var valid_579189 = query.getOrDefault("quotaUser")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "quotaUser", valid_579189
  var valid_579190 = query.getOrDefault("callback")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = nil)
  if valid_579190 != nil:
    section.add "callback", valid_579190
  var valid_579191 = query.getOrDefault("fields")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = nil)
  if valid_579191 != nil:
    section.add "fields", valid_579191
  var valid_579192 = query.getOrDefault("access_token")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "access_token", valid_579192
  var valid_579193 = query.getOrDefault("upload_protocol")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "upload_protocol", valid_579193
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

proc call*(call_579195: Call_DialogflowProjectsAgentSessionsContextsCreate_579179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a context.
  ## 
  ## If the specified context already exists, overrides the context.
  ## 
  let valid = call_579195.validator(path, query, header, formData, body)
  let scheme = call_579195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579195.url(scheme.get, call_579195.host, call_579195.base,
                         call_579195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579195, url, valid)

proc call*(call_579196: Call_DialogflowProjectsAgentSessionsContextsCreate_579179;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentSessionsContextsCreate
  ## Creates a context.
  ## 
  ## If the specified context already exists, overrides the context.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The session to create a context for.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579197 = newJObject()
  var query_579198 = newJObject()
  var body_579199 = newJObject()
  add(query_579198, "key", newJString(key))
  add(query_579198, "prettyPrint", newJBool(prettyPrint))
  add(query_579198, "oauth_token", newJString(oauthToken))
  add(query_579198, "$.xgafv", newJString(Xgafv))
  add(query_579198, "alt", newJString(alt))
  add(query_579198, "uploadType", newJString(uploadType))
  add(query_579198, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579199 = body
  add(query_579198, "callback", newJString(callback))
  add(path_579197, "parent", newJString(parent))
  add(query_579198, "fields", newJString(fields))
  add(query_579198, "access_token", newJString(accessToken))
  add(query_579198, "upload_protocol", newJString(uploadProtocol))
  result = call_579196.call(path_579197, query_579198, nil, nil, body_579199)

var dialogflowProjectsAgentSessionsContextsCreate* = Call_DialogflowProjectsAgentSessionsContextsCreate_579179(
    name: "dialogflowProjectsAgentSessionsContextsCreate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/contexts",
    validator: validate_DialogflowProjectsAgentSessionsContextsCreate_579180,
    base: "/", url: url_DialogflowProjectsAgentSessionsContextsCreate_579181,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsContextsList_579158 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentSessionsContextsList_579160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/contexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsContextsList_579159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all contexts in the specified session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The session to list all contexts from.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579161 = path.getOrDefault("parent")
  valid_579161 = validateParameter(valid_579161, JString, required = true,
                                 default = nil)
  if valid_579161 != nil:
    section.add "parent", valid_579161
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. The next_page_token value returned from a previous list request.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579162 = query.getOrDefault("key")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "key", valid_579162
  var valid_579163 = query.getOrDefault("prettyPrint")
  valid_579163 = validateParameter(valid_579163, JBool, required = false,
                                 default = newJBool(true))
  if valid_579163 != nil:
    section.add "prettyPrint", valid_579163
  var valid_579164 = query.getOrDefault("oauth_token")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "oauth_token", valid_579164
  var valid_579165 = query.getOrDefault("$.xgafv")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = newJString("1"))
  if valid_579165 != nil:
    section.add "$.xgafv", valid_579165
  var valid_579166 = query.getOrDefault("pageSize")
  valid_579166 = validateParameter(valid_579166, JInt, required = false, default = nil)
  if valid_579166 != nil:
    section.add "pageSize", valid_579166
  var valid_579167 = query.getOrDefault("alt")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = newJString("json"))
  if valid_579167 != nil:
    section.add "alt", valid_579167
  var valid_579168 = query.getOrDefault("uploadType")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "uploadType", valid_579168
  var valid_579169 = query.getOrDefault("quotaUser")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "quotaUser", valid_579169
  var valid_579170 = query.getOrDefault("pageToken")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "pageToken", valid_579170
  var valid_579171 = query.getOrDefault("callback")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "callback", valid_579171
  var valid_579172 = query.getOrDefault("fields")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "fields", valid_579172
  var valid_579173 = query.getOrDefault("access_token")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "access_token", valid_579173
  var valid_579174 = query.getOrDefault("upload_protocol")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "upload_protocol", valid_579174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579175: Call_DialogflowProjectsAgentSessionsContextsList_579158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all contexts in the specified session.
  ## 
  let valid = call_579175.validator(path, query, header, formData, body)
  let scheme = call_579175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579175.url(scheme.get, call_579175.host, call_579175.base,
                         call_579175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579175, url, valid)

proc call*(call_579176: Call_DialogflowProjectsAgentSessionsContextsList_579158;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentSessionsContextsList
  ## Returns the list of all contexts in the specified session.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. The next_page_token value returned from a previous list request.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The session to list all contexts from.
  ## Format: `projects/<Project ID>/agent/sessions/<Session ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579177 = newJObject()
  var query_579178 = newJObject()
  add(query_579178, "key", newJString(key))
  add(query_579178, "prettyPrint", newJBool(prettyPrint))
  add(query_579178, "oauth_token", newJString(oauthToken))
  add(query_579178, "$.xgafv", newJString(Xgafv))
  add(query_579178, "pageSize", newJInt(pageSize))
  add(query_579178, "alt", newJString(alt))
  add(query_579178, "uploadType", newJString(uploadType))
  add(query_579178, "quotaUser", newJString(quotaUser))
  add(query_579178, "pageToken", newJString(pageToken))
  add(query_579178, "callback", newJString(callback))
  add(path_579177, "parent", newJString(parent))
  add(query_579178, "fields", newJString(fields))
  add(query_579178, "access_token", newJString(accessToken))
  add(query_579178, "upload_protocol", newJString(uploadProtocol))
  result = call_579176.call(path_579177, query_579178, nil, nil, nil)

var dialogflowProjectsAgentSessionsContextsList* = Call_DialogflowProjectsAgentSessionsContextsList_579158(
    name: "dialogflowProjectsAgentSessionsContextsList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/contexts",
    validator: validate_DialogflowProjectsAgentSessionsContextsList_579159,
    base: "/", url: url_DialogflowProjectsAgentSessionsContextsList_579160,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsDeleteContexts_579200 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentSessionsDeleteContexts_579202(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/contexts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsDeleteContexts_579201(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes all active contexts in the specified session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the session to delete all contexts from. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579203 = path.getOrDefault("parent")
  valid_579203 = validateParameter(valid_579203, JString, required = true,
                                 default = nil)
  if valid_579203 != nil:
    section.add "parent", valid_579203
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579204 = query.getOrDefault("key")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "key", valid_579204
  var valid_579205 = query.getOrDefault("prettyPrint")
  valid_579205 = validateParameter(valid_579205, JBool, required = false,
                                 default = newJBool(true))
  if valid_579205 != nil:
    section.add "prettyPrint", valid_579205
  var valid_579206 = query.getOrDefault("oauth_token")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "oauth_token", valid_579206
  var valid_579207 = query.getOrDefault("$.xgafv")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = newJString("1"))
  if valid_579207 != nil:
    section.add "$.xgafv", valid_579207
  var valid_579208 = query.getOrDefault("alt")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = newJString("json"))
  if valid_579208 != nil:
    section.add "alt", valid_579208
  var valid_579209 = query.getOrDefault("uploadType")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "uploadType", valid_579209
  var valid_579210 = query.getOrDefault("quotaUser")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "quotaUser", valid_579210
  var valid_579211 = query.getOrDefault("callback")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "callback", valid_579211
  var valid_579212 = query.getOrDefault("fields")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "fields", valid_579212
  var valid_579213 = query.getOrDefault("access_token")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = nil)
  if valid_579213 != nil:
    section.add "access_token", valid_579213
  var valid_579214 = query.getOrDefault("upload_protocol")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "upload_protocol", valid_579214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579215: Call_DialogflowProjectsAgentSessionsDeleteContexts_579200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes all active contexts in the specified session.
  ## 
  let valid = call_579215.validator(path, query, header, formData, body)
  let scheme = call_579215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579215.url(scheme.get, call_579215.host, call_579215.base,
                         call_579215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579215, url, valid)

proc call*(call_579216: Call_DialogflowProjectsAgentSessionsDeleteContexts_579200;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentSessionsDeleteContexts
  ## Deletes all active contexts in the specified session.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the session to delete all contexts from. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579217 = newJObject()
  var query_579218 = newJObject()
  add(query_579218, "key", newJString(key))
  add(query_579218, "prettyPrint", newJBool(prettyPrint))
  add(query_579218, "oauth_token", newJString(oauthToken))
  add(query_579218, "$.xgafv", newJString(Xgafv))
  add(query_579218, "alt", newJString(alt))
  add(query_579218, "uploadType", newJString(uploadType))
  add(query_579218, "quotaUser", newJString(quotaUser))
  add(query_579218, "callback", newJString(callback))
  add(path_579217, "parent", newJString(parent))
  add(query_579218, "fields", newJString(fields))
  add(query_579218, "access_token", newJString(accessToken))
  add(query_579218, "upload_protocol", newJString(uploadProtocol))
  result = call_579216.call(path_579217, query_579218, nil, nil, nil)

var dialogflowProjectsAgentSessionsDeleteContexts* = Call_DialogflowProjectsAgentSessionsDeleteContexts_579200(
    name: "dialogflowProjectsAgentSessionsDeleteContexts",
    meth: HttpMethod.HttpDelete, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/contexts",
    validator: validate_DialogflowProjectsAgentSessionsDeleteContexts_579201,
    base: "/", url: url_DialogflowProjectsAgentSessionsDeleteContexts_579202,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579219 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579221(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entities:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579220(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates multiple new entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the entity type to create entities in. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579222 = path.getOrDefault("parent")
  valid_579222 = validateParameter(valid_579222, JString, required = true,
                                 default = nil)
  if valid_579222 != nil:
    section.add "parent", valid_579222
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579223 = query.getOrDefault("key")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "key", valid_579223
  var valid_579224 = query.getOrDefault("prettyPrint")
  valid_579224 = validateParameter(valid_579224, JBool, required = false,
                                 default = newJBool(true))
  if valid_579224 != nil:
    section.add "prettyPrint", valid_579224
  var valid_579225 = query.getOrDefault("oauth_token")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "oauth_token", valid_579225
  var valid_579226 = query.getOrDefault("$.xgafv")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = newJString("1"))
  if valid_579226 != nil:
    section.add "$.xgafv", valid_579226
  var valid_579227 = query.getOrDefault("alt")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = newJString("json"))
  if valid_579227 != nil:
    section.add "alt", valid_579227
  var valid_579228 = query.getOrDefault("uploadType")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "uploadType", valid_579228
  var valid_579229 = query.getOrDefault("quotaUser")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "quotaUser", valid_579229
  var valid_579230 = query.getOrDefault("callback")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "callback", valid_579230
  var valid_579231 = query.getOrDefault("fields")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "fields", valid_579231
  var valid_579232 = query.getOrDefault("access_token")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "access_token", valid_579232
  var valid_579233 = query.getOrDefault("upload_protocol")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = nil)
  if valid_579233 != nil:
    section.add "upload_protocol", valid_579233
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

proc call*(call_579235: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579235.validator(path, query, header, formData, body)
  let scheme = call_579235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579235.url(scheme.get, call_579235.host, call_579235.base,
                         call_579235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579235, url, valid)

proc call*(call_579236: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579219;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesEntitiesBatchCreate
  ## Creates multiple new entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the entity type to create entities in. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579237 = newJObject()
  var query_579238 = newJObject()
  var body_579239 = newJObject()
  add(query_579238, "key", newJString(key))
  add(query_579238, "prettyPrint", newJBool(prettyPrint))
  add(query_579238, "oauth_token", newJString(oauthToken))
  add(query_579238, "$.xgafv", newJString(Xgafv))
  add(query_579238, "alt", newJString(alt))
  add(query_579238, "uploadType", newJString(uploadType))
  add(query_579238, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579239 = body
  add(query_579238, "callback", newJString(callback))
  add(path_579237, "parent", newJString(parent))
  add(query_579238, "fields", newJString(fields))
  add(query_579238, "access_token", newJString(accessToken))
  add(query_579238, "upload_protocol", newJString(uploadProtocol))
  result = call_579236.call(path_579237, query_579238, nil, nil, body_579239)

var dialogflowProjectsAgentEntityTypesEntitiesBatchCreate* = Call_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579219(
    name: "dialogflowProjectsAgentEntityTypesEntitiesBatchCreate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entities:batchCreate",
    validator: validate_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579220,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesEntitiesBatchCreate_579221,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579240 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579242(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entities:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579241(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the entity type to delete entries for. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579243 = path.getOrDefault("parent")
  valid_579243 = validateParameter(valid_579243, JString, required = true,
                                 default = nil)
  if valid_579243 != nil:
    section.add "parent", valid_579243
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579244 = query.getOrDefault("key")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = nil)
  if valid_579244 != nil:
    section.add "key", valid_579244
  var valid_579245 = query.getOrDefault("prettyPrint")
  valid_579245 = validateParameter(valid_579245, JBool, required = false,
                                 default = newJBool(true))
  if valid_579245 != nil:
    section.add "prettyPrint", valid_579245
  var valid_579246 = query.getOrDefault("oauth_token")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "oauth_token", valid_579246
  var valid_579247 = query.getOrDefault("$.xgafv")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = newJString("1"))
  if valid_579247 != nil:
    section.add "$.xgafv", valid_579247
  var valid_579248 = query.getOrDefault("alt")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = newJString("json"))
  if valid_579248 != nil:
    section.add "alt", valid_579248
  var valid_579249 = query.getOrDefault("uploadType")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "uploadType", valid_579249
  var valid_579250 = query.getOrDefault("quotaUser")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "quotaUser", valid_579250
  var valid_579251 = query.getOrDefault("callback")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "callback", valid_579251
  var valid_579252 = query.getOrDefault("fields")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "fields", valid_579252
  var valid_579253 = query.getOrDefault("access_token")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = nil)
  if valid_579253 != nil:
    section.add "access_token", valid_579253
  var valid_579254 = query.getOrDefault("upload_protocol")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "upload_protocol", valid_579254
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

proc call*(call_579256: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579256.validator(path, query, header, formData, body)
  let scheme = call_579256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579256.url(scheme.get, call_579256.host, call_579256.base,
                         call_579256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579256, url, valid)

proc call*(call_579257: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579240;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesEntitiesBatchDelete
  ## Deletes entities in the specified entity type.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the entity type to delete entries for. Format:
  ## `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579258 = newJObject()
  var query_579259 = newJObject()
  var body_579260 = newJObject()
  add(query_579259, "key", newJString(key))
  add(query_579259, "prettyPrint", newJBool(prettyPrint))
  add(query_579259, "oauth_token", newJString(oauthToken))
  add(query_579259, "$.xgafv", newJString(Xgafv))
  add(query_579259, "alt", newJString(alt))
  add(query_579259, "uploadType", newJString(uploadType))
  add(query_579259, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579260 = body
  add(query_579259, "callback", newJString(callback))
  add(path_579258, "parent", newJString(parent))
  add(query_579259, "fields", newJString(fields))
  add(query_579259, "access_token", newJString(accessToken))
  add(query_579259, "upload_protocol", newJString(uploadProtocol))
  result = call_579257.call(path_579258, query_579259, nil, nil, body_579260)

var dialogflowProjectsAgentEntityTypesEntitiesBatchDelete* = Call_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579240(
    name: "dialogflowProjectsAgentEntityTypesEntitiesBatchDelete",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entities:batchDelete",
    validator: validate_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579241,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesEntitiesBatchDelete_579242,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579261 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579263(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entities:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579262(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates or creates multiple entities in the specified entity type. This
  ## method does not affect entities in the entity type that aren't explicitly
  ## specified in the request.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the entity type to update or create entities in.
  ## Format: `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579264 = path.getOrDefault("parent")
  valid_579264 = validateParameter(valid_579264, JString, required = true,
                                 default = nil)
  if valid_579264 != nil:
    section.add "parent", valid_579264
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579265 = query.getOrDefault("key")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "key", valid_579265
  var valid_579266 = query.getOrDefault("prettyPrint")
  valid_579266 = validateParameter(valid_579266, JBool, required = false,
                                 default = newJBool(true))
  if valid_579266 != nil:
    section.add "prettyPrint", valid_579266
  var valid_579267 = query.getOrDefault("oauth_token")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "oauth_token", valid_579267
  var valid_579268 = query.getOrDefault("$.xgafv")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = newJString("1"))
  if valid_579268 != nil:
    section.add "$.xgafv", valid_579268
  var valid_579269 = query.getOrDefault("alt")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = newJString("json"))
  if valid_579269 != nil:
    section.add "alt", valid_579269
  var valid_579270 = query.getOrDefault("uploadType")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "uploadType", valid_579270
  var valid_579271 = query.getOrDefault("quotaUser")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "quotaUser", valid_579271
  var valid_579272 = query.getOrDefault("callback")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "callback", valid_579272
  var valid_579273 = query.getOrDefault("fields")
  valid_579273 = validateParameter(valid_579273, JString, required = false,
                                 default = nil)
  if valid_579273 != nil:
    section.add "fields", valid_579273
  var valid_579274 = query.getOrDefault("access_token")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "access_token", valid_579274
  var valid_579275 = query.getOrDefault("upload_protocol")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = nil)
  if valid_579275 != nil:
    section.add "upload_protocol", valid_579275
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

proc call*(call_579277: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates or creates multiple entities in the specified entity type. This
  ## method does not affect entities in the entity type that aren't explicitly
  ## specified in the request.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579277.validator(path, query, header, formData, body)
  let scheme = call_579277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579277.url(scheme.get, call_579277.host, call_579277.base,
                         call_579277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579277, url, valid)

proc call*(call_579278: Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579261;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesEntitiesBatchUpdate
  ## Updates or creates multiple entities in the specified entity type. This
  ## method does not affect entities in the entity type that aren't explicitly
  ## specified in the request.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the entity type to update or create entities in.
  ## Format: `projects/<Project ID>/agent/entityTypes/<Entity Type ID>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579279 = newJObject()
  var query_579280 = newJObject()
  var body_579281 = newJObject()
  add(query_579280, "key", newJString(key))
  add(query_579280, "prettyPrint", newJBool(prettyPrint))
  add(query_579280, "oauth_token", newJString(oauthToken))
  add(query_579280, "$.xgafv", newJString(Xgafv))
  add(query_579280, "alt", newJString(alt))
  add(query_579280, "uploadType", newJString(uploadType))
  add(query_579280, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579281 = body
  add(query_579280, "callback", newJString(callback))
  add(path_579279, "parent", newJString(parent))
  add(query_579280, "fields", newJString(fields))
  add(query_579280, "access_token", newJString(accessToken))
  add(query_579280, "upload_protocol", newJString(uploadProtocol))
  result = call_579278.call(path_579279, query_579280, nil, nil, body_579281)

var dialogflowProjectsAgentEntityTypesEntitiesBatchUpdate* = Call_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579261(
    name: "dialogflowProjectsAgentEntityTypesEntitiesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entities:batchUpdate",
    validator: validate_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579262,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesEntitiesBatchUpdate_579263,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesCreate_579304 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesCreate_579306(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesCreate_579305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an entity type in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to create a entity type for.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579307 = path.getOrDefault("parent")
  valid_579307 = validateParameter(valid_579307, JString, required = true,
                                 default = nil)
  if valid_579307 != nil:
    section.add "parent", valid_579307
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional. The language of entity synonyms defined in `entity_type`. If not
  ## specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579308 = query.getOrDefault("key")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = nil)
  if valid_579308 != nil:
    section.add "key", valid_579308
  var valid_579309 = query.getOrDefault("prettyPrint")
  valid_579309 = validateParameter(valid_579309, JBool, required = false,
                                 default = newJBool(true))
  if valid_579309 != nil:
    section.add "prettyPrint", valid_579309
  var valid_579310 = query.getOrDefault("oauth_token")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "oauth_token", valid_579310
  var valid_579311 = query.getOrDefault("$.xgafv")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = newJString("1"))
  if valid_579311 != nil:
    section.add "$.xgafv", valid_579311
  var valid_579312 = query.getOrDefault("alt")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = newJString("json"))
  if valid_579312 != nil:
    section.add "alt", valid_579312
  var valid_579313 = query.getOrDefault("uploadType")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "uploadType", valid_579313
  var valid_579314 = query.getOrDefault("quotaUser")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "quotaUser", valid_579314
  var valid_579315 = query.getOrDefault("callback")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "callback", valid_579315
  var valid_579316 = query.getOrDefault("languageCode")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "languageCode", valid_579316
  var valid_579317 = query.getOrDefault("fields")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "fields", valid_579317
  var valid_579318 = query.getOrDefault("access_token")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = nil)
  if valid_579318 != nil:
    section.add "access_token", valid_579318
  var valid_579319 = query.getOrDefault("upload_protocol")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "upload_protocol", valid_579319
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

proc call*(call_579321: Call_DialogflowProjectsAgentEntityTypesCreate_579304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an entity type in the specified agent.
  ## 
  let valid = call_579321.validator(path, query, header, formData, body)
  let scheme = call_579321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579321.url(scheme.get, call_579321.host, call_579321.base,
                         call_579321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579321, url, valid)

proc call*(call_579322: Call_DialogflowProjectsAgentEntityTypesCreate_579304;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesCreate
  ## Creates an entity type in the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The agent to create a entity type for.
  ## Format: `projects/<Project ID>/agent`.
  ##   languageCode: string
  ##               : Optional. The language of entity synonyms defined in `entity_type`. If not
  ## specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579323 = newJObject()
  var query_579324 = newJObject()
  var body_579325 = newJObject()
  add(query_579324, "key", newJString(key))
  add(query_579324, "prettyPrint", newJBool(prettyPrint))
  add(query_579324, "oauth_token", newJString(oauthToken))
  add(query_579324, "$.xgafv", newJString(Xgafv))
  add(query_579324, "alt", newJString(alt))
  add(query_579324, "uploadType", newJString(uploadType))
  add(query_579324, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579325 = body
  add(query_579324, "callback", newJString(callback))
  add(path_579323, "parent", newJString(parent))
  add(query_579324, "languageCode", newJString(languageCode))
  add(query_579324, "fields", newJString(fields))
  add(query_579324, "access_token", newJString(accessToken))
  add(query_579324, "upload_protocol", newJString(uploadProtocol))
  result = call_579322.call(path_579323, query_579324, nil, nil, body_579325)

var dialogflowProjectsAgentEntityTypesCreate* = Call_DialogflowProjectsAgentEntityTypesCreate_579304(
    name: "dialogflowProjectsAgentEntityTypesCreate", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/entityTypes",
    validator: validate_DialogflowProjectsAgentEntityTypesCreate_579305,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesCreate_579306,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesList_579282 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesList_579284(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesList_579283(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all entity types in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to list all entity types from.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579285 = path.getOrDefault("parent")
  valid_579285 = validateParameter(valid_579285, JString, required = true,
                                 default = nil)
  if valid_579285 != nil:
    section.add "parent", valid_579285
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. The next_page_token value returned from a previous list request.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional. The language to list entity synonyms for. If not specified,
  ## the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579286 = query.getOrDefault("key")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "key", valid_579286
  var valid_579287 = query.getOrDefault("prettyPrint")
  valid_579287 = validateParameter(valid_579287, JBool, required = false,
                                 default = newJBool(true))
  if valid_579287 != nil:
    section.add "prettyPrint", valid_579287
  var valid_579288 = query.getOrDefault("oauth_token")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "oauth_token", valid_579288
  var valid_579289 = query.getOrDefault("$.xgafv")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = newJString("1"))
  if valid_579289 != nil:
    section.add "$.xgafv", valid_579289
  var valid_579290 = query.getOrDefault("pageSize")
  valid_579290 = validateParameter(valid_579290, JInt, required = false, default = nil)
  if valid_579290 != nil:
    section.add "pageSize", valid_579290
  var valid_579291 = query.getOrDefault("alt")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = newJString("json"))
  if valid_579291 != nil:
    section.add "alt", valid_579291
  var valid_579292 = query.getOrDefault("uploadType")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "uploadType", valid_579292
  var valid_579293 = query.getOrDefault("quotaUser")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "quotaUser", valid_579293
  var valid_579294 = query.getOrDefault("pageToken")
  valid_579294 = validateParameter(valid_579294, JString, required = false,
                                 default = nil)
  if valid_579294 != nil:
    section.add "pageToken", valid_579294
  var valid_579295 = query.getOrDefault("callback")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "callback", valid_579295
  var valid_579296 = query.getOrDefault("languageCode")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = nil)
  if valid_579296 != nil:
    section.add "languageCode", valid_579296
  var valid_579297 = query.getOrDefault("fields")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "fields", valid_579297
  var valid_579298 = query.getOrDefault("access_token")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "access_token", valid_579298
  var valid_579299 = query.getOrDefault("upload_protocol")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "upload_protocol", valid_579299
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579300: Call_DialogflowProjectsAgentEntityTypesList_579282;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all entity types in the specified agent.
  ## 
  let valid = call_579300.validator(path, query, header, formData, body)
  let scheme = call_579300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579300.url(scheme.get, call_579300.host, call_579300.base,
                         call_579300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579300, url, valid)

proc call*(call_579301: Call_DialogflowProjectsAgentEntityTypesList_579282;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; languageCode: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesList
  ## Returns the list of all entity types in the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. The next_page_token value returned from a previous list request.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The agent to list all entity types from.
  ## Format: `projects/<Project ID>/agent`.
  ##   languageCode: string
  ##               : Optional. The language to list entity synonyms for. If not specified,
  ## the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579302 = newJObject()
  var query_579303 = newJObject()
  add(query_579303, "key", newJString(key))
  add(query_579303, "prettyPrint", newJBool(prettyPrint))
  add(query_579303, "oauth_token", newJString(oauthToken))
  add(query_579303, "$.xgafv", newJString(Xgafv))
  add(query_579303, "pageSize", newJInt(pageSize))
  add(query_579303, "alt", newJString(alt))
  add(query_579303, "uploadType", newJString(uploadType))
  add(query_579303, "quotaUser", newJString(quotaUser))
  add(query_579303, "pageToken", newJString(pageToken))
  add(query_579303, "callback", newJString(callback))
  add(path_579302, "parent", newJString(parent))
  add(query_579303, "languageCode", newJString(languageCode))
  add(query_579303, "fields", newJString(fields))
  add(query_579303, "access_token", newJString(accessToken))
  add(query_579303, "upload_protocol", newJString(uploadProtocol))
  result = call_579301.call(path_579302, query_579303, nil, nil, nil)

var dialogflowProjectsAgentEntityTypesList* = Call_DialogflowProjectsAgentEntityTypesList_579282(
    name: "dialogflowProjectsAgentEntityTypesList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/entityTypes",
    validator: validate_DialogflowProjectsAgentEntityTypesList_579283, base: "/",
    url: url_DialogflowProjectsAgentEntityTypesList_579284,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesBatchDelete_579326 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesBatchDelete_579328(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesBatchDelete_579327(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes entity types in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579329 = path.getOrDefault("parent")
  valid_579329 = validateParameter(valid_579329, JString, required = true,
                                 default = nil)
  if valid_579329 != nil:
    section.add "parent", valid_579329
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579330 = query.getOrDefault("key")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "key", valid_579330
  var valid_579331 = query.getOrDefault("prettyPrint")
  valid_579331 = validateParameter(valid_579331, JBool, required = false,
                                 default = newJBool(true))
  if valid_579331 != nil:
    section.add "prettyPrint", valid_579331
  var valid_579332 = query.getOrDefault("oauth_token")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "oauth_token", valid_579332
  var valid_579333 = query.getOrDefault("$.xgafv")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = newJString("1"))
  if valid_579333 != nil:
    section.add "$.xgafv", valid_579333
  var valid_579334 = query.getOrDefault("alt")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = newJString("json"))
  if valid_579334 != nil:
    section.add "alt", valid_579334
  var valid_579335 = query.getOrDefault("uploadType")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "uploadType", valid_579335
  var valid_579336 = query.getOrDefault("quotaUser")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "quotaUser", valid_579336
  var valid_579337 = query.getOrDefault("callback")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "callback", valid_579337
  var valid_579338 = query.getOrDefault("fields")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "fields", valid_579338
  var valid_579339 = query.getOrDefault("access_token")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = nil)
  if valid_579339 != nil:
    section.add "access_token", valid_579339
  var valid_579340 = query.getOrDefault("upload_protocol")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "upload_protocol", valid_579340
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

proc call*(call_579342: Call_DialogflowProjectsAgentEntityTypesBatchDelete_579326;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes entity types in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579342.validator(path, query, header, formData, body)
  let scheme = call_579342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579342.url(scheme.get, call_579342.host, call_579342.base,
                         call_579342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579342, url, valid)

proc call*(call_579343: Call_DialogflowProjectsAgentEntityTypesBatchDelete_579326;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesBatchDelete
  ## Deletes entity types in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579344 = newJObject()
  var query_579345 = newJObject()
  var body_579346 = newJObject()
  add(query_579345, "key", newJString(key))
  add(query_579345, "prettyPrint", newJBool(prettyPrint))
  add(query_579345, "oauth_token", newJString(oauthToken))
  add(query_579345, "$.xgafv", newJString(Xgafv))
  add(query_579345, "alt", newJString(alt))
  add(query_579345, "uploadType", newJString(uploadType))
  add(query_579345, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579346 = body
  add(query_579345, "callback", newJString(callback))
  add(path_579344, "parent", newJString(parent))
  add(query_579345, "fields", newJString(fields))
  add(query_579345, "access_token", newJString(accessToken))
  add(query_579345, "upload_protocol", newJString(uploadProtocol))
  result = call_579343.call(path_579344, query_579345, nil, nil, body_579346)

var dialogflowProjectsAgentEntityTypesBatchDelete* = Call_DialogflowProjectsAgentEntityTypesBatchDelete_579326(
    name: "dialogflowProjectsAgentEntityTypesBatchDelete",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entityTypes:batchDelete",
    validator: validate_DialogflowProjectsAgentEntityTypesBatchDelete_579327,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesBatchDelete_579328,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentEntityTypesBatchUpdate_579347 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentEntityTypesBatchUpdate_579349(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/entityTypes:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentEntityTypesBatchUpdate_579348(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates/Creates multiple entity types in the specified agent.
  ## 
  ## Operation <response: BatchUpdateEntityTypesResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to update or create entity types in.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579350 = path.getOrDefault("parent")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "parent", valid_579350
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579351 = query.getOrDefault("key")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "key", valid_579351
  var valid_579352 = query.getOrDefault("prettyPrint")
  valid_579352 = validateParameter(valid_579352, JBool, required = false,
                                 default = newJBool(true))
  if valid_579352 != nil:
    section.add "prettyPrint", valid_579352
  var valid_579353 = query.getOrDefault("oauth_token")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "oauth_token", valid_579353
  var valid_579354 = query.getOrDefault("$.xgafv")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = newJString("1"))
  if valid_579354 != nil:
    section.add "$.xgafv", valid_579354
  var valid_579355 = query.getOrDefault("alt")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = newJString("json"))
  if valid_579355 != nil:
    section.add "alt", valid_579355
  var valid_579356 = query.getOrDefault("uploadType")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "uploadType", valid_579356
  var valid_579357 = query.getOrDefault("quotaUser")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "quotaUser", valid_579357
  var valid_579358 = query.getOrDefault("callback")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "callback", valid_579358
  var valid_579359 = query.getOrDefault("fields")
  valid_579359 = validateParameter(valid_579359, JString, required = false,
                                 default = nil)
  if valid_579359 != nil:
    section.add "fields", valid_579359
  var valid_579360 = query.getOrDefault("access_token")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "access_token", valid_579360
  var valid_579361 = query.getOrDefault("upload_protocol")
  valid_579361 = validateParameter(valid_579361, JString, required = false,
                                 default = nil)
  if valid_579361 != nil:
    section.add "upload_protocol", valid_579361
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

proc call*(call_579363: Call_DialogflowProjectsAgentEntityTypesBatchUpdate_579347;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates/Creates multiple entity types in the specified agent.
  ## 
  ## Operation <response: BatchUpdateEntityTypesResponse>
  ## 
  let valid = call_579363.validator(path, query, header, formData, body)
  let scheme = call_579363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579363.url(scheme.get, call_579363.host, call_579363.base,
                         call_579363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579363, url, valid)

proc call*(call_579364: Call_DialogflowProjectsAgentEntityTypesBatchUpdate_579347;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentEntityTypesBatchUpdate
  ## Updates/Creates multiple entity types in the specified agent.
  ## 
  ## Operation <response: BatchUpdateEntityTypesResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the agent to update or create entity types in.
  ## Format: `projects/<Project ID>/agent`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579365 = newJObject()
  var query_579366 = newJObject()
  var body_579367 = newJObject()
  add(query_579366, "key", newJString(key))
  add(query_579366, "prettyPrint", newJBool(prettyPrint))
  add(query_579366, "oauth_token", newJString(oauthToken))
  add(query_579366, "$.xgafv", newJString(Xgafv))
  add(query_579366, "alt", newJString(alt))
  add(query_579366, "uploadType", newJString(uploadType))
  add(query_579366, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579367 = body
  add(query_579366, "callback", newJString(callback))
  add(path_579365, "parent", newJString(parent))
  add(query_579366, "fields", newJString(fields))
  add(query_579366, "access_token", newJString(accessToken))
  add(query_579366, "upload_protocol", newJString(uploadProtocol))
  result = call_579364.call(path_579365, query_579366, nil, nil, body_579367)

var dialogflowProjectsAgentEntityTypesBatchUpdate* = Call_DialogflowProjectsAgentEntityTypesBatchUpdate_579347(
    name: "dialogflowProjectsAgentEntityTypesBatchUpdate",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{parent}/entityTypes:batchUpdate",
    validator: validate_DialogflowProjectsAgentEntityTypesBatchUpdate_579348,
    base: "/", url: url_DialogflowProjectsAgentEntityTypesBatchUpdate_579349,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsCreate_579391 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentIntentsCreate_579393(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsCreate_579392(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an intent in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to create a intent for.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579394 = path.getOrDefault("parent")
  valid_579394 = validateParameter(valid_579394, JString, required = true,
                                 default = nil)
  if valid_579394 != nil:
    section.add "parent", valid_579394
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579395 = query.getOrDefault("key")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "key", valid_579395
  var valid_579396 = query.getOrDefault("prettyPrint")
  valid_579396 = validateParameter(valid_579396, JBool, required = false,
                                 default = newJBool(true))
  if valid_579396 != nil:
    section.add "prettyPrint", valid_579396
  var valid_579397 = query.getOrDefault("oauth_token")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "oauth_token", valid_579397
  var valid_579398 = query.getOrDefault("$.xgafv")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = newJString("1"))
  if valid_579398 != nil:
    section.add "$.xgafv", valid_579398
  var valid_579399 = query.getOrDefault("alt")
  valid_579399 = validateParameter(valid_579399, JString, required = false,
                                 default = newJString("json"))
  if valid_579399 != nil:
    section.add "alt", valid_579399
  var valid_579400 = query.getOrDefault("uploadType")
  valid_579400 = validateParameter(valid_579400, JString, required = false,
                                 default = nil)
  if valid_579400 != nil:
    section.add "uploadType", valid_579400
  var valid_579401 = query.getOrDefault("quotaUser")
  valid_579401 = validateParameter(valid_579401, JString, required = false,
                                 default = nil)
  if valid_579401 != nil:
    section.add "quotaUser", valid_579401
  var valid_579402 = query.getOrDefault("intentView")
  valid_579402 = validateParameter(valid_579402, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_579402 != nil:
    section.add "intentView", valid_579402
  var valid_579403 = query.getOrDefault("callback")
  valid_579403 = validateParameter(valid_579403, JString, required = false,
                                 default = nil)
  if valid_579403 != nil:
    section.add "callback", valid_579403
  var valid_579404 = query.getOrDefault("languageCode")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "languageCode", valid_579404
  var valid_579405 = query.getOrDefault("fields")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = nil)
  if valid_579405 != nil:
    section.add "fields", valid_579405
  var valid_579406 = query.getOrDefault("access_token")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "access_token", valid_579406
  var valid_579407 = query.getOrDefault("upload_protocol")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "upload_protocol", valid_579407
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

proc call*(call_579409: Call_DialogflowProjectsAgentIntentsCreate_579391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an intent in the specified agent.
  ## 
  let valid = call_579409.validator(path, query, header, formData, body)
  let scheme = call_579409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579409.url(scheme.get, call_579409.host, call_579409.base,
                         call_579409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579409, url, valid)

proc call*(call_579410: Call_DialogflowProjectsAgentIntentsCreate_579391;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = "";
          intentView: string = "INTENT_VIEW_UNSPECIFIED"; body: JsonNode = nil;
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsCreate
  ## Creates an intent in the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The agent to create a intent for.
  ## Format: `projects/<Project ID>/agent`.
  ##   languageCode: string
  ##               : Optional. The language of training phrases, parameters and rich messages
  ## defined in `intent`. If not specified, the agent's default language is
  ## used. [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579411 = newJObject()
  var query_579412 = newJObject()
  var body_579413 = newJObject()
  add(query_579412, "key", newJString(key))
  add(query_579412, "prettyPrint", newJBool(prettyPrint))
  add(query_579412, "oauth_token", newJString(oauthToken))
  add(query_579412, "$.xgafv", newJString(Xgafv))
  add(query_579412, "alt", newJString(alt))
  add(query_579412, "uploadType", newJString(uploadType))
  add(query_579412, "quotaUser", newJString(quotaUser))
  add(query_579412, "intentView", newJString(intentView))
  if body != nil:
    body_579413 = body
  add(query_579412, "callback", newJString(callback))
  add(path_579411, "parent", newJString(parent))
  add(query_579412, "languageCode", newJString(languageCode))
  add(query_579412, "fields", newJString(fields))
  add(query_579412, "access_token", newJString(accessToken))
  add(query_579412, "upload_protocol", newJString(uploadProtocol))
  result = call_579410.call(path_579411, query_579412, nil, nil, body_579413)

var dialogflowProjectsAgentIntentsCreate* = Call_DialogflowProjectsAgentIntentsCreate_579391(
    name: "dialogflowProjectsAgentIntentsCreate", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents",
    validator: validate_DialogflowProjectsAgentIntentsCreate_579392, base: "/",
    url: url_DialogflowProjectsAgentIntentsCreate_579393, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsList_579368 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentIntentsList_579370(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsList_579369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the list of all intents in the specified agent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The agent to list all intents from.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579371 = path.getOrDefault("parent")
  valid_579371 = validateParameter(valid_579371, JString, required = true,
                                 default = nil)
  if valid_579371 != nil:
    section.add "parent", valid_579371
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : Optional. The next_page_token value returned from a previous list request.
  ##   intentView: JString
  ##             : Optional. The resource view to apply to the returned intent.
  ##   callback: JString
  ##           : JSONP
  ##   languageCode: JString
  ##               : Optional. The language to list training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579372 = query.getOrDefault("key")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "key", valid_579372
  var valid_579373 = query.getOrDefault("prettyPrint")
  valid_579373 = validateParameter(valid_579373, JBool, required = false,
                                 default = newJBool(true))
  if valid_579373 != nil:
    section.add "prettyPrint", valid_579373
  var valid_579374 = query.getOrDefault("oauth_token")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "oauth_token", valid_579374
  var valid_579375 = query.getOrDefault("$.xgafv")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = newJString("1"))
  if valid_579375 != nil:
    section.add "$.xgafv", valid_579375
  var valid_579376 = query.getOrDefault("pageSize")
  valid_579376 = validateParameter(valid_579376, JInt, required = false, default = nil)
  if valid_579376 != nil:
    section.add "pageSize", valid_579376
  var valid_579377 = query.getOrDefault("alt")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = newJString("json"))
  if valid_579377 != nil:
    section.add "alt", valid_579377
  var valid_579378 = query.getOrDefault("uploadType")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = nil)
  if valid_579378 != nil:
    section.add "uploadType", valid_579378
  var valid_579379 = query.getOrDefault("quotaUser")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "quotaUser", valid_579379
  var valid_579380 = query.getOrDefault("pageToken")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "pageToken", valid_579380
  var valid_579381 = query.getOrDefault("intentView")
  valid_579381 = validateParameter(valid_579381, JString, required = false, default = newJString(
      "INTENT_VIEW_UNSPECIFIED"))
  if valid_579381 != nil:
    section.add "intentView", valid_579381
  var valid_579382 = query.getOrDefault("callback")
  valid_579382 = validateParameter(valid_579382, JString, required = false,
                                 default = nil)
  if valid_579382 != nil:
    section.add "callback", valid_579382
  var valid_579383 = query.getOrDefault("languageCode")
  valid_579383 = validateParameter(valid_579383, JString, required = false,
                                 default = nil)
  if valid_579383 != nil:
    section.add "languageCode", valid_579383
  var valid_579384 = query.getOrDefault("fields")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "fields", valid_579384
  var valid_579385 = query.getOrDefault("access_token")
  valid_579385 = validateParameter(valid_579385, JString, required = false,
                                 default = nil)
  if valid_579385 != nil:
    section.add "access_token", valid_579385
  var valid_579386 = query.getOrDefault("upload_protocol")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "upload_protocol", valid_579386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579387: Call_DialogflowProjectsAgentIntentsList_579368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the list of all intents in the specified agent.
  ## 
  let valid = call_579387.validator(path, query, header, formData, body)
  let scheme = call_579387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579387.url(scheme.get, call_579387.host, call_579387.base,
                         call_579387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579387, url, valid)

proc call*(call_579388: Call_DialogflowProjectsAgentIntentsList_579368;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; intentView: string = "INTENT_VIEW_UNSPECIFIED";
          callback: string = ""; languageCode: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsList
  ## Returns the list of all intents in the specified agent.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of items to return in a single page. By
  ## default 100 and at most 1000.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : Optional. The next_page_token value returned from a previous list request.
  ##   intentView: string
  ##             : Optional. The resource view to apply to the returned intent.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The agent to list all intents from.
  ## Format: `projects/<Project ID>/agent`.
  ##   languageCode: string
  ##               : Optional. The language to list training phrases, parameters and rich
  ## messages for. If not specified, the agent's default language is used.
  ## [Many
  ## languages](https://cloud.google.com/dialogflow/docs/reference/language)
  ## are supported. Note: languages must be enabled in the agent before they can
  ## be used.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579389 = newJObject()
  var query_579390 = newJObject()
  add(query_579390, "key", newJString(key))
  add(query_579390, "prettyPrint", newJBool(prettyPrint))
  add(query_579390, "oauth_token", newJString(oauthToken))
  add(query_579390, "$.xgafv", newJString(Xgafv))
  add(query_579390, "pageSize", newJInt(pageSize))
  add(query_579390, "alt", newJString(alt))
  add(query_579390, "uploadType", newJString(uploadType))
  add(query_579390, "quotaUser", newJString(quotaUser))
  add(query_579390, "pageToken", newJString(pageToken))
  add(query_579390, "intentView", newJString(intentView))
  add(query_579390, "callback", newJString(callback))
  add(path_579389, "parent", newJString(parent))
  add(query_579390, "languageCode", newJString(languageCode))
  add(query_579390, "fields", newJString(fields))
  add(query_579390, "access_token", newJString(accessToken))
  add(query_579390, "upload_protocol", newJString(uploadProtocol))
  result = call_579388.call(path_579389, query_579390, nil, nil, nil)

var dialogflowProjectsAgentIntentsList* = Call_DialogflowProjectsAgentIntentsList_579368(
    name: "dialogflowProjectsAgentIntentsList", meth: HttpMethod.HttpGet,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents",
    validator: validate_DialogflowProjectsAgentIntentsList_579369, base: "/",
    url: url_DialogflowProjectsAgentIntentsList_579370, schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsBatchDelete_579414 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentIntentsBatchDelete_579416(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents:batchDelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsBatchDelete_579415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes intents in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579417 = path.getOrDefault("parent")
  valid_579417 = validateParameter(valid_579417, JString, required = true,
                                 default = nil)
  if valid_579417 != nil:
    section.add "parent", valid_579417
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579418 = query.getOrDefault("key")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "key", valid_579418
  var valid_579419 = query.getOrDefault("prettyPrint")
  valid_579419 = validateParameter(valid_579419, JBool, required = false,
                                 default = newJBool(true))
  if valid_579419 != nil:
    section.add "prettyPrint", valid_579419
  var valid_579420 = query.getOrDefault("oauth_token")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "oauth_token", valid_579420
  var valid_579421 = query.getOrDefault("$.xgafv")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = newJString("1"))
  if valid_579421 != nil:
    section.add "$.xgafv", valid_579421
  var valid_579422 = query.getOrDefault("alt")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = newJString("json"))
  if valid_579422 != nil:
    section.add "alt", valid_579422
  var valid_579423 = query.getOrDefault("uploadType")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "uploadType", valid_579423
  var valid_579424 = query.getOrDefault("quotaUser")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "quotaUser", valid_579424
  var valid_579425 = query.getOrDefault("callback")
  valid_579425 = validateParameter(valid_579425, JString, required = false,
                                 default = nil)
  if valid_579425 != nil:
    section.add "callback", valid_579425
  var valid_579426 = query.getOrDefault("fields")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "fields", valid_579426
  var valid_579427 = query.getOrDefault("access_token")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = nil)
  if valid_579427 != nil:
    section.add "access_token", valid_579427
  var valid_579428 = query.getOrDefault("upload_protocol")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "upload_protocol", valid_579428
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

proc call*(call_579430: Call_DialogflowProjectsAgentIntentsBatchDelete_579414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes intents in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ## 
  let valid = call_579430.validator(path, query, header, formData, body)
  let scheme = call_579430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579430.url(scheme.get, call_579430.host, call_579430.base,
                         call_579430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579430, url, valid)

proc call*(call_579431: Call_DialogflowProjectsAgentIntentsBatchDelete_579414;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsBatchDelete
  ## Deletes intents in the specified agent.
  ## 
  ## Operation <response: google.protobuf.Empty>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the agent to delete all entities types for. Format:
  ## `projects/<Project ID>/agent`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579432 = newJObject()
  var query_579433 = newJObject()
  var body_579434 = newJObject()
  add(query_579433, "key", newJString(key))
  add(query_579433, "prettyPrint", newJBool(prettyPrint))
  add(query_579433, "oauth_token", newJString(oauthToken))
  add(query_579433, "$.xgafv", newJString(Xgafv))
  add(query_579433, "alt", newJString(alt))
  add(query_579433, "uploadType", newJString(uploadType))
  add(query_579433, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579434 = body
  add(query_579433, "callback", newJString(callback))
  add(path_579432, "parent", newJString(parent))
  add(query_579433, "fields", newJString(fields))
  add(query_579433, "access_token", newJString(accessToken))
  add(query_579433, "upload_protocol", newJString(uploadProtocol))
  result = call_579431.call(path_579432, query_579433, nil, nil, body_579434)

var dialogflowProjectsAgentIntentsBatchDelete* = Call_DialogflowProjectsAgentIntentsBatchDelete_579414(
    name: "dialogflowProjectsAgentIntentsBatchDelete", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents:batchDelete",
    validator: validate_DialogflowProjectsAgentIntentsBatchDelete_579415,
    base: "/", url: url_DialogflowProjectsAgentIntentsBatchDelete_579416,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentIntentsBatchUpdate_579435 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentIntentsBatchUpdate_579437(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/intents:batchUpdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentIntentsBatchUpdate_579436(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates/Creates multiple intents in the specified agent.
  ## 
  ## Operation <response: BatchUpdateIntentsResponse>
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the agent to update or create intents in.
  ## Format: `projects/<Project ID>/agent`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579438 = path.getOrDefault("parent")
  valid_579438 = validateParameter(valid_579438, JString, required = true,
                                 default = nil)
  if valid_579438 != nil:
    section.add "parent", valid_579438
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579439 = query.getOrDefault("key")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "key", valid_579439
  var valid_579440 = query.getOrDefault("prettyPrint")
  valid_579440 = validateParameter(valid_579440, JBool, required = false,
                                 default = newJBool(true))
  if valid_579440 != nil:
    section.add "prettyPrint", valid_579440
  var valid_579441 = query.getOrDefault("oauth_token")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "oauth_token", valid_579441
  var valid_579442 = query.getOrDefault("$.xgafv")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("1"))
  if valid_579442 != nil:
    section.add "$.xgafv", valid_579442
  var valid_579443 = query.getOrDefault("alt")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = newJString("json"))
  if valid_579443 != nil:
    section.add "alt", valid_579443
  var valid_579444 = query.getOrDefault("uploadType")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "uploadType", valid_579444
  var valid_579445 = query.getOrDefault("quotaUser")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "quotaUser", valid_579445
  var valid_579446 = query.getOrDefault("callback")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "callback", valid_579446
  var valid_579447 = query.getOrDefault("fields")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "fields", valid_579447
  var valid_579448 = query.getOrDefault("access_token")
  valid_579448 = validateParameter(valid_579448, JString, required = false,
                                 default = nil)
  if valid_579448 != nil:
    section.add "access_token", valid_579448
  var valid_579449 = query.getOrDefault("upload_protocol")
  valid_579449 = validateParameter(valid_579449, JString, required = false,
                                 default = nil)
  if valid_579449 != nil:
    section.add "upload_protocol", valid_579449
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

proc call*(call_579451: Call_DialogflowProjectsAgentIntentsBatchUpdate_579435;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates/Creates multiple intents in the specified agent.
  ## 
  ## Operation <response: BatchUpdateIntentsResponse>
  ## 
  let valid = call_579451.validator(path, query, header, formData, body)
  let scheme = call_579451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579451.url(scheme.get, call_579451.host, call_579451.base,
                         call_579451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579451, url, valid)

proc call*(call_579452: Call_DialogflowProjectsAgentIntentsBatchUpdate_579435;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentIntentsBatchUpdate
  ## Updates/Creates multiple intents in the specified agent.
  ## 
  ## Operation <response: BatchUpdateIntentsResponse>
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the agent to update or create intents in.
  ## Format: `projects/<Project ID>/agent`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579453 = newJObject()
  var query_579454 = newJObject()
  var body_579455 = newJObject()
  add(query_579454, "key", newJString(key))
  add(query_579454, "prettyPrint", newJBool(prettyPrint))
  add(query_579454, "oauth_token", newJString(oauthToken))
  add(query_579454, "$.xgafv", newJString(Xgafv))
  add(query_579454, "alt", newJString(alt))
  add(query_579454, "uploadType", newJString(uploadType))
  add(query_579454, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579455 = body
  add(query_579454, "callback", newJString(callback))
  add(path_579453, "parent", newJString(parent))
  add(query_579454, "fields", newJString(fields))
  add(query_579454, "access_token", newJString(accessToken))
  add(query_579454, "upload_protocol", newJString(uploadProtocol))
  result = call_579452.call(path_579453, query_579454, nil, nil, body_579455)

var dialogflowProjectsAgentIntentsBatchUpdate* = Call_DialogflowProjectsAgentIntentsBatchUpdate_579435(
    name: "dialogflowProjectsAgentIntentsBatchUpdate", meth: HttpMethod.HttpPost,
    host: "dialogflow.googleapis.com", route: "/v2/{parent}/intents:batchUpdate",
    validator: validate_DialogflowProjectsAgentIntentsBatchUpdate_579436,
    base: "/", url: url_DialogflowProjectsAgentIntentsBatchUpdate_579437,
    schemes: {Scheme.Https})
type
  Call_DialogflowProjectsAgentSessionsDetectIntent_579456 = ref object of OpenApiRestCall_578348
proc url_DialogflowProjectsAgentSessionsDetectIntent_579458(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":detectIntent")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DialogflowProjectsAgentSessionsDetectIntent_579457(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Processes a natural language query and returns structured, actionable data
  ## as a result. This method is not idempotent, because it may cause contexts
  ## and session entity types to be updated, which in turn might affect
  ## results of future queries.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The name of the session this query is sent to. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`. It's up to the API
  ## caller to choose an appropriate session ID. It can be a random number or
  ## some type of user identifier (preferably hashed). The length of the session
  ## ID must not exceed 36 bytes.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_579459 = path.getOrDefault("session")
  valid_579459 = validateParameter(valid_579459, JString, required = true,
                                 default = nil)
  if valid_579459 != nil:
    section.add "session", valid_579459
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579460 = query.getOrDefault("key")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "key", valid_579460
  var valid_579461 = query.getOrDefault("prettyPrint")
  valid_579461 = validateParameter(valid_579461, JBool, required = false,
                                 default = newJBool(true))
  if valid_579461 != nil:
    section.add "prettyPrint", valid_579461
  var valid_579462 = query.getOrDefault("oauth_token")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "oauth_token", valid_579462
  var valid_579463 = query.getOrDefault("$.xgafv")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = newJString("1"))
  if valid_579463 != nil:
    section.add "$.xgafv", valid_579463
  var valid_579464 = query.getOrDefault("alt")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = newJString("json"))
  if valid_579464 != nil:
    section.add "alt", valid_579464
  var valid_579465 = query.getOrDefault("uploadType")
  valid_579465 = validateParameter(valid_579465, JString, required = false,
                                 default = nil)
  if valid_579465 != nil:
    section.add "uploadType", valid_579465
  var valid_579466 = query.getOrDefault("quotaUser")
  valid_579466 = validateParameter(valid_579466, JString, required = false,
                                 default = nil)
  if valid_579466 != nil:
    section.add "quotaUser", valid_579466
  var valid_579467 = query.getOrDefault("callback")
  valid_579467 = validateParameter(valid_579467, JString, required = false,
                                 default = nil)
  if valid_579467 != nil:
    section.add "callback", valid_579467
  var valid_579468 = query.getOrDefault("fields")
  valid_579468 = validateParameter(valid_579468, JString, required = false,
                                 default = nil)
  if valid_579468 != nil:
    section.add "fields", valid_579468
  var valid_579469 = query.getOrDefault("access_token")
  valid_579469 = validateParameter(valid_579469, JString, required = false,
                                 default = nil)
  if valid_579469 != nil:
    section.add "access_token", valid_579469
  var valid_579470 = query.getOrDefault("upload_protocol")
  valid_579470 = validateParameter(valid_579470, JString, required = false,
                                 default = nil)
  if valid_579470 != nil:
    section.add "upload_protocol", valid_579470
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

proc call*(call_579472: Call_DialogflowProjectsAgentSessionsDetectIntent_579456;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Processes a natural language query and returns structured, actionable data
  ## as a result. This method is not idempotent, because it may cause contexts
  ## and session entity types to be updated, which in turn might affect
  ## results of future queries.
  ## 
  let valid = call_579472.validator(path, query, header, formData, body)
  let scheme = call_579472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579472.url(scheme.get, call_579472.host, call_579472.base,
                         call_579472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579472, url, valid)

proc call*(call_579473: Call_DialogflowProjectsAgentSessionsDetectIntent_579456;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## dialogflowProjectsAgentSessionsDetectIntent
  ## Processes a natural language query and returns structured, actionable data
  ## as a result. This method is not idempotent, because it may cause contexts
  ## and session entity types to be updated, which in turn might affect
  ## results of future queries.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The name of the session this query is sent to. Format:
  ## `projects/<Project ID>/agent/sessions/<Session ID>`. It's up to the API
  ## caller to choose an appropriate session ID. It can be a random number or
  ## some type of user identifier (preferably hashed). The length of the session
  ## ID must not exceed 36 bytes.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579474 = newJObject()
  var query_579475 = newJObject()
  var body_579476 = newJObject()
  add(query_579475, "key", newJString(key))
  add(query_579475, "prettyPrint", newJBool(prettyPrint))
  add(query_579475, "oauth_token", newJString(oauthToken))
  add(query_579475, "$.xgafv", newJString(Xgafv))
  add(query_579475, "alt", newJString(alt))
  add(query_579475, "uploadType", newJString(uploadType))
  add(query_579475, "quotaUser", newJString(quotaUser))
  add(path_579474, "session", newJString(session))
  if body != nil:
    body_579476 = body
  add(query_579475, "callback", newJString(callback))
  add(query_579475, "fields", newJString(fields))
  add(query_579475, "access_token", newJString(accessToken))
  add(query_579475, "upload_protocol", newJString(uploadProtocol))
  result = call_579473.call(path_579474, query_579475, nil, nil, body_579476)

var dialogflowProjectsAgentSessionsDetectIntent* = Call_DialogflowProjectsAgentSessionsDetectIntent_579456(
    name: "dialogflowProjectsAgentSessionsDetectIntent",
    meth: HttpMethod.HttpPost, host: "dialogflow.googleapis.com",
    route: "/v2/{session}:detectIntent",
    validator: validate_DialogflowProjectsAgentSessionsDetectIntent_579457,
    base: "/", url: url_DialogflowProjectsAgentSessionsDetectIntent_579458,
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
