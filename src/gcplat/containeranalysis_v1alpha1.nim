
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Container Analysis
## version: v1alpha1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## An implementation of the Grafeas API, which stores, and enables querying and retrieval of critical metadata about all of your software artifacts.
## 
## https://cloud.google.com/container-analysis/api/reference/rest/
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
  gcpServiceName = "containeranalysis"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ContaineranalysisProvidersNotesGet_578619 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesGet_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesGet_578620(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
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
  ##   callback: JString
  ##           : JSONP
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
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_ContaineranalysisProvidersNotesGet_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the requested `Note`.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_ContaineranalysisProvidersNotesGet_578619;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesGet
  ## Returns the requested `Note`.
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
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578866 = newJObject()
  var query_578868 = newJObject()
  add(query_578868, "key", newJString(key))
  add(query_578868, "prettyPrint", newJBool(prettyPrint))
  add(query_578868, "oauth_token", newJString(oauthToken))
  add(query_578868, "$.xgafv", newJString(Xgafv))
  add(query_578868, "alt", newJString(alt))
  add(query_578868, "uploadType", newJString(uploadType))
  add(query_578868, "quotaUser", newJString(quotaUser))
  add(path_578866, "name", newJString(name))
  add(query_578868, "callback", newJString(callback))
  add(query_578868, "fields", newJString(fields))
  add(query_578868, "access_token", newJString(accessToken))
  add(query_578868, "upload_protocol", newJString(uploadProtocol))
  result = call_578865.call(path_578866, query_578868, nil, nil, nil)

var containeranalysisProvidersNotesGet* = Call_ContaineranalysisProvidersNotesGet_578619(
    name: "containeranalysisProvidersNotesGet", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProvidersNotesGet_578620, base: "/",
    url: url_ContaineranalysisProvidersNotesGet_578621, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesPatch_578926 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesPatch_578928(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesPatch_578927(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note.
  ## Should be of the form "projects/{provider_id}/notes/{note_id}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578929 = path.getOrDefault("name")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "name", valid_578929
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
  ##             : The fields to update.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("uploadType")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "uploadType", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("updateMask")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "updateMask", valid_578937
  var valid_578938 = query.getOrDefault("callback")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "callback", valid_578938
  var valid_578939 = query.getOrDefault("fields")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "fields", valid_578939
  var valid_578940 = query.getOrDefault("access_token")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "access_token", valid_578940
  var valid_578941 = query.getOrDefault("upload_protocol")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "upload_protocol", valid_578941
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

proc call*(call_578943: Call_ContaineranalysisProvidersNotesPatch_578926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing `Note`.
  ## 
  let valid = call_578943.validator(path, query, header, formData, body)
  let scheme = call_578943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578943.url(scheme.get, call_578943.host, call_578943.base,
                         call_578943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578943, url, valid)

proc call*(call_578944: Call_ContaineranalysisProvidersNotesPatch_578926;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesPatch
  ## Updates an existing `Note`.
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
  ##       : The name of the note.
  ## Should be of the form "projects/{provider_id}/notes/{note_id}".
  ##   updateMask: string
  ##             : The fields to update.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578945 = newJObject()
  var query_578946 = newJObject()
  var body_578947 = newJObject()
  add(query_578946, "key", newJString(key))
  add(query_578946, "prettyPrint", newJBool(prettyPrint))
  add(query_578946, "oauth_token", newJString(oauthToken))
  add(query_578946, "$.xgafv", newJString(Xgafv))
  add(query_578946, "alt", newJString(alt))
  add(query_578946, "uploadType", newJString(uploadType))
  add(query_578946, "quotaUser", newJString(quotaUser))
  add(path_578945, "name", newJString(name))
  add(query_578946, "updateMask", newJString(updateMask))
  if body != nil:
    body_578947 = body
  add(query_578946, "callback", newJString(callback))
  add(query_578946, "fields", newJString(fields))
  add(query_578946, "access_token", newJString(accessToken))
  add(query_578946, "upload_protocol", newJString(uploadProtocol))
  result = call_578944.call(path_578945, query_578946, nil, nil, body_578947)

var containeranalysisProvidersNotesPatch* = Call_ContaineranalysisProvidersNotesPatch_578926(
    name: "containeranalysisProvidersNotesPatch", meth: HttpMethod.HttpPatch,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProvidersNotesPatch_578927, base: "/",
    url: url_ContaineranalysisProvidersNotesPatch_578928, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesDelete_578907 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesDelete_578909(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesDelete_578908(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the given `Note` from the system.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578910 = path.getOrDefault("name")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "name", valid_578910
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
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_ContaineranalysisProvidersNotesDelete_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the given `Note` from the system.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_ContaineranalysisProvidersNotesDelete_578907;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesDelete
  ## Deletes the given `Note` from the system.
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
  ##       : The name of the note in the form of
  ## "providers/{provider_id}/notes/{NOTE_ID}"
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(query_578925, "$.xgafv", newJString(Xgafv))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "uploadType", newJString(uploadType))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(path_578924, "name", newJString(name))
  add(query_578925, "callback", newJString(callback))
  add(query_578925, "fields", newJString(fields))
  add(query_578925, "access_token", newJString(accessToken))
  add(query_578925, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var containeranalysisProvidersNotesDelete* = Call_ContaineranalysisProvidersNotesDelete_578907(
    name: "containeranalysisProvidersNotesDelete", meth: HttpMethod.HttpDelete,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}",
    validator: validate_ContaineranalysisProvidersNotesDelete_578908, base: "/",
    url: url_ContaineranalysisProvidersNotesDelete_578909, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesCreate_578971 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesCreate_578973(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesCreate_578972(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578974 = path.getOrDefault("name")
  valid_578974 = validateParameter(valid_578974, JString, required = true,
                                 default = nil)
  if valid_578974 != nil:
    section.add "name", valid_578974
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
  ##   parent: JString
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   noteId: JString
  ##         : The ID to use for this note.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578975 = query.getOrDefault("key")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "key", valid_578975
  var valid_578976 = query.getOrDefault("prettyPrint")
  valid_578976 = validateParameter(valid_578976, JBool, required = false,
                                 default = newJBool(true))
  if valid_578976 != nil:
    section.add "prettyPrint", valid_578976
  var valid_578977 = query.getOrDefault("oauth_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "oauth_token", valid_578977
  var valid_578978 = query.getOrDefault("$.xgafv")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = newJString("1"))
  if valid_578978 != nil:
    section.add "$.xgafv", valid_578978
  var valid_578979 = query.getOrDefault("alt")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("json"))
  if valid_578979 != nil:
    section.add "alt", valid_578979
  var valid_578980 = query.getOrDefault("uploadType")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "uploadType", valid_578980
  var valid_578981 = query.getOrDefault("parent")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "parent", valid_578981
  var valid_578982 = query.getOrDefault("quotaUser")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "quotaUser", valid_578982
  var valid_578983 = query.getOrDefault("noteId")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "noteId", valid_578983
  var valid_578984 = query.getOrDefault("callback")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "callback", valid_578984
  var valid_578985 = query.getOrDefault("fields")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "fields", valid_578985
  var valid_578986 = query.getOrDefault("access_token")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "access_token", valid_578986
  var valid_578987 = query.getOrDefault("upload_protocol")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "upload_protocol", valid_578987
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

proc call*(call_578989: Call_ContaineranalysisProvidersNotesCreate_578971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_578989.validator(path, query, header, formData, body)
  let scheme = call_578989.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578989.url(scheme.get, call_578989.host, call_578989.base,
                         call_578989.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578989, url, valid)

proc call*(call_578990: Call_ContaineranalysisProvidersNotesCreate_578971;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; parent: string = ""; quotaUser: string = "";
          noteId: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesCreate
  ## Creates a new `Note`.
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
  ##   parent: string
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   body: JObject
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
  var body_578993 = newJObject()
  add(query_578992, "key", newJString(key))
  add(query_578992, "prettyPrint", newJBool(prettyPrint))
  add(query_578992, "oauth_token", newJString(oauthToken))
  add(query_578992, "$.xgafv", newJString(Xgafv))
  add(query_578992, "alt", newJString(alt))
  add(query_578992, "uploadType", newJString(uploadType))
  add(query_578992, "parent", newJString(parent))
  add(query_578992, "quotaUser", newJString(quotaUser))
  add(path_578991, "name", newJString(name))
  add(query_578992, "noteId", newJString(noteId))
  if body != nil:
    body_578993 = body
  add(query_578992, "callback", newJString(callback))
  add(query_578992, "fields", newJString(fields))
  add(query_578992, "access_token", newJString(accessToken))
  add(query_578992, "upload_protocol", newJString(uploadProtocol))
  result = call_578990.call(path_578991, query_578992, nil, nil, body_578993)

var containeranalysisProvidersNotesCreate* = Call_ContaineranalysisProvidersNotesCreate_578971(
    name: "containeranalysisProvidersNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProvidersNotesCreate_578972, base: "/",
    url: url_ContaineranalysisProvidersNotesCreate_578973, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesList_578948 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesList_578950(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesList_578949(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all `Notes` for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578951 = path.getOrDefault("name")
  valid_578951 = validateParameter(valid_578951, JString, required = true,
                                 default = nil)
  if valid_578951 != nil:
    section.add "name", valid_578951
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
  ##           : Number of notes to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: JString
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578952 = query.getOrDefault("key")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "key", valid_578952
  var valid_578953 = query.getOrDefault("prettyPrint")
  valid_578953 = validateParameter(valid_578953, JBool, required = false,
                                 default = newJBool(true))
  if valid_578953 != nil:
    section.add "prettyPrint", valid_578953
  var valid_578954 = query.getOrDefault("oauth_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "oauth_token", valid_578954
  var valid_578955 = query.getOrDefault("$.xgafv")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = newJString("1"))
  if valid_578955 != nil:
    section.add "$.xgafv", valid_578955
  var valid_578956 = query.getOrDefault("pageSize")
  valid_578956 = validateParameter(valid_578956, JInt, required = false, default = nil)
  if valid_578956 != nil:
    section.add "pageSize", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("uploadType")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "uploadType", valid_578958
  var valid_578959 = query.getOrDefault("parent")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "parent", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("filter")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "filter", valid_578961
  var valid_578962 = query.getOrDefault("pageToken")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "pageToken", valid_578962
  var valid_578963 = query.getOrDefault("callback")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "callback", valid_578963
  var valid_578964 = query.getOrDefault("fields")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "fields", valid_578964
  var valid_578965 = query.getOrDefault("access_token")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "access_token", valid_578965
  var valid_578966 = query.getOrDefault("upload_protocol")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "upload_protocol", valid_578966
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578967: Call_ContaineranalysisProvidersNotesList_578948;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all `Notes` for a given project.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_ContaineranalysisProvidersNotesList_578948;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; parent: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesList
  ## Lists all `Notes` for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578969 = newJObject()
  var query_578970 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "pageSize", newJInt(pageSize))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(query_578970, "parent", newJString(parent))
  add(query_578970, "quotaUser", newJString(quotaUser))
  add(path_578969, "name", newJString(name))
  add(query_578970, "filter", newJString(filter))
  add(query_578970, "pageToken", newJString(pageToken))
  add(query_578970, "callback", newJString(callback))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578968.call(path_578969, query_578970, nil, nil, nil)

var containeranalysisProvidersNotesList* = Call_ContaineranalysisProvidersNotesList_578948(
    name: "containeranalysisProvidersNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{name}/notes",
    validator: validate_ContaineranalysisProvidersNotesList_578949, base: "/",
    url: url_ContaineranalysisProvidersNotesList_578950, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesOccurrencesList_578994 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesOccurrencesList_578996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesOccurrencesList_578995(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578997 = path.getOrDefault("name")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "name", valid_578997
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
  ##           : Number of notes to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("$.xgafv")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("1"))
  if valid_579001 != nil:
    section.add "$.xgafv", valid_579001
  var valid_579002 = query.getOrDefault("pageSize")
  valid_579002 = validateParameter(valid_579002, JInt, required = false, default = nil)
  if valid_579002 != nil:
    section.add "pageSize", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("uploadType")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "uploadType", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("filter")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "filter", valid_579006
  var valid_579007 = query.getOrDefault("pageToken")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "pageToken", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579012: Call_ContaineranalysisProvidersNotesOccurrencesList_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ## 
  let valid = call_579012.validator(path, query, header, formData, body)
  let scheme = call_579012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579012.url(scheme.get, call_579012.host, call_579012.base,
                         call_579012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579012, url, valid)

proc call*(call_579013: Call_ContaineranalysisProvidersNotesOccurrencesList_578994;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesOccurrencesList
  ## Lists `Occurrences` referencing the specified `Note`. Use this method to
  ## get all occurrences referencing your `Note` across all your customer
  ## projects.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name field will contain the note name for example:
  ##   "provider/{provider_id}/notes/{note_id}"
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579014 = newJObject()
  var query_579015 = newJObject()
  add(query_579015, "key", newJString(key))
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(query_579015, "$.xgafv", newJString(Xgafv))
  add(query_579015, "pageSize", newJInt(pageSize))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "uploadType", newJString(uploadType))
  add(query_579015, "quotaUser", newJString(quotaUser))
  add(path_579014, "name", newJString(name))
  add(query_579015, "filter", newJString(filter))
  add(query_579015, "pageToken", newJString(pageToken))
  add(query_579015, "callback", newJString(callback))
  add(query_579015, "fields", newJString(fields))
  add(query_579015, "access_token", newJString(accessToken))
  add(query_579015, "upload_protocol", newJString(uploadProtocol))
  result = call_579013.call(path_579014, query_579015, nil, nil, nil)

var containeranalysisProvidersNotesOccurrencesList* = Call_ContaineranalysisProvidersNotesOccurrencesList_578994(
    name: "containeranalysisProvidersNotesOccurrencesList",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{name}/occurrences",
    validator: validate_ContaineranalysisProvidersNotesOccurrencesList_578995,
    base: "/", url: url_ContaineranalysisProvidersNotesOccurrencesList_578996,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesCreate_579039 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesCreate_579041(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesCreate_579040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Note`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579042 = path.getOrDefault("parent")
  valid_579042 = validateParameter(valid_579042, JString, required = true,
                                 default = nil)
  if valid_579042 != nil:
    section.add "parent", valid_579042
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   noteId: JString
  ##         : The ID to use for this note.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579043 = query.getOrDefault("key")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "key", valid_579043
  var valid_579044 = query.getOrDefault("prettyPrint")
  valid_579044 = validateParameter(valid_579044, JBool, required = false,
                                 default = newJBool(true))
  if valid_579044 != nil:
    section.add "prettyPrint", valid_579044
  var valid_579045 = query.getOrDefault("oauth_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "oauth_token", valid_579045
  var valid_579046 = query.getOrDefault("name")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "name", valid_579046
  var valid_579047 = query.getOrDefault("$.xgafv")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = newJString("1"))
  if valid_579047 != nil:
    section.add "$.xgafv", valid_579047
  var valid_579048 = query.getOrDefault("alt")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = newJString("json"))
  if valid_579048 != nil:
    section.add "alt", valid_579048
  var valid_579049 = query.getOrDefault("uploadType")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "uploadType", valid_579049
  var valid_579050 = query.getOrDefault("quotaUser")
  valid_579050 = validateParameter(valid_579050, JString, required = false,
                                 default = nil)
  if valid_579050 != nil:
    section.add "quotaUser", valid_579050
  var valid_579051 = query.getOrDefault("noteId")
  valid_579051 = validateParameter(valid_579051, JString, required = false,
                                 default = nil)
  if valid_579051 != nil:
    section.add "noteId", valid_579051
  var valid_579052 = query.getOrDefault("callback")
  valid_579052 = validateParameter(valid_579052, JString, required = false,
                                 default = nil)
  if valid_579052 != nil:
    section.add "callback", valid_579052
  var valid_579053 = query.getOrDefault("fields")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "fields", valid_579053
  var valid_579054 = query.getOrDefault("access_token")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "access_token", valid_579054
  var valid_579055 = query.getOrDefault("upload_protocol")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "upload_protocol", valid_579055
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

proc call*(call_579057: Call_ContaineranalysisProjectsNotesCreate_579039;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Note`.
  ## 
  let valid = call_579057.validator(path, query, header, formData, body)
  let scheme = call_579057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579057.url(scheme.get, call_579057.host, call_579057.base,
                         call_579057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579057, url, valid)

proc call*(call_579058: Call_ContaineranalysisProjectsNotesCreate_579039;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          noteId: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesCreate
  ## Creates a new `Note`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name of the project.
  ## Should be of the form "providers/{provider_id}".
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   noteId: string
  ##         : The ID to use for this note.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : This field contains the project Id for example:
  ## "projects/{project_id}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579059 = newJObject()
  var query_579060 = newJObject()
  var body_579061 = newJObject()
  add(query_579060, "key", newJString(key))
  add(query_579060, "prettyPrint", newJBool(prettyPrint))
  add(query_579060, "oauth_token", newJString(oauthToken))
  add(query_579060, "name", newJString(name))
  add(query_579060, "$.xgafv", newJString(Xgafv))
  add(query_579060, "alt", newJString(alt))
  add(query_579060, "uploadType", newJString(uploadType))
  add(query_579060, "quotaUser", newJString(quotaUser))
  add(query_579060, "noteId", newJString(noteId))
  if body != nil:
    body_579061 = body
  add(query_579060, "callback", newJString(callback))
  add(path_579059, "parent", newJString(parent))
  add(query_579060, "fields", newJString(fields))
  add(query_579060, "access_token", newJString(accessToken))
  add(query_579060, "upload_protocol", newJString(uploadProtocol))
  result = call_579058.call(path_579059, query_579060, nil, nil, body_579061)

var containeranalysisProjectsNotesCreate* = Call_ContaineranalysisProjectsNotesCreate_579039(
    name: "containeranalysisProjectsNotesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesCreate_579040, base: "/",
    url: url_ContaineranalysisProjectsNotesCreate_579041, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsNotesList_579016 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsNotesList_579018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/notes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsNotesList_579017(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all `Notes` for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579019 = path.getOrDefault("parent")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "parent", valid_579019
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of notes to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579020 = query.getOrDefault("key")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "key", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("name")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "name", valid_579023
  var valid_579024 = query.getOrDefault("$.xgafv")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("1"))
  if valid_579024 != nil:
    section.add "$.xgafv", valid_579024
  var valid_579025 = query.getOrDefault("pageSize")
  valid_579025 = validateParameter(valid_579025, JInt, required = false, default = nil)
  if valid_579025 != nil:
    section.add "pageSize", valid_579025
  var valid_579026 = query.getOrDefault("alt")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = newJString("json"))
  if valid_579026 != nil:
    section.add "alt", valid_579026
  var valid_579027 = query.getOrDefault("uploadType")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "uploadType", valid_579027
  var valid_579028 = query.getOrDefault("quotaUser")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "quotaUser", valid_579028
  var valid_579029 = query.getOrDefault("filter")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "filter", valid_579029
  var valid_579030 = query.getOrDefault("pageToken")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "pageToken", valid_579030
  var valid_579031 = query.getOrDefault("callback")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "callback", valid_579031
  var valid_579032 = query.getOrDefault("fields")
  valid_579032 = validateParameter(valid_579032, JString, required = false,
                                 default = nil)
  if valid_579032 != nil:
    section.add "fields", valid_579032
  var valid_579033 = query.getOrDefault("access_token")
  valid_579033 = validateParameter(valid_579033, JString, required = false,
                                 default = nil)
  if valid_579033 != nil:
    section.add "access_token", valid_579033
  var valid_579034 = query.getOrDefault("upload_protocol")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "upload_protocol", valid_579034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579035: Call_ContaineranalysisProjectsNotesList_579016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all `Notes` for a given project.
  ## 
  let valid = call_579035.validator(path, query, header, formData, body)
  let scheme = call_579035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579035.url(scheme.get, call_579035.host, call_579035.base,
                         call_579035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579035, url, valid)

proc call*(call_579036: Call_ContaineranalysisProjectsNotesList_579016;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsNotesList
  ## Lists all `Notes` for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name field will contain the project Id for example:
  ## "providers/{provider_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of notes to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : This field contains the project Id for example: "projects/{PROJECT_ID}".
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579037 = newJObject()
  var query_579038 = newJObject()
  add(query_579038, "key", newJString(key))
  add(query_579038, "prettyPrint", newJBool(prettyPrint))
  add(query_579038, "oauth_token", newJString(oauthToken))
  add(query_579038, "name", newJString(name))
  add(query_579038, "$.xgafv", newJString(Xgafv))
  add(query_579038, "pageSize", newJInt(pageSize))
  add(query_579038, "alt", newJString(alt))
  add(query_579038, "uploadType", newJString(uploadType))
  add(query_579038, "quotaUser", newJString(quotaUser))
  add(query_579038, "filter", newJString(filter))
  add(query_579038, "pageToken", newJString(pageToken))
  add(query_579038, "callback", newJString(callback))
  add(path_579037, "parent", newJString(parent))
  add(query_579038, "fields", newJString(fields))
  add(query_579038, "access_token", newJString(accessToken))
  add(query_579038, "upload_protocol", newJString(uploadProtocol))
  result = call_579036.call(path_579037, query_579038, nil, nil, nil)

var containeranalysisProjectsNotesList* = Call_ContaineranalysisProjectsNotesList_579016(
    name: "containeranalysisProjectsNotesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com", route: "/v1alpha1/{parent}/notes",
    validator: validate_ContaineranalysisProjectsNotesList_579017, base: "/",
    url: url_ContaineranalysisProjectsNotesList_579018, schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesCreate_579086 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesCreate_579088(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesCreate_579087(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This field contains the project Id for example: "projects/{project_id}"
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579089 = path.getOrDefault("parent")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "parent", valid_579089
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
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
  var valid_579090 = query.getOrDefault("key")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "key", valid_579090
  var valid_579091 = query.getOrDefault("prettyPrint")
  valid_579091 = validateParameter(valid_579091, JBool, required = false,
                                 default = newJBool(true))
  if valid_579091 != nil:
    section.add "prettyPrint", valid_579091
  var valid_579092 = query.getOrDefault("oauth_token")
  valid_579092 = validateParameter(valid_579092, JString, required = false,
                                 default = nil)
  if valid_579092 != nil:
    section.add "oauth_token", valid_579092
  var valid_579093 = query.getOrDefault("name")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "name", valid_579093
  var valid_579094 = query.getOrDefault("$.xgafv")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("1"))
  if valid_579094 != nil:
    section.add "$.xgafv", valid_579094
  var valid_579095 = query.getOrDefault("alt")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = newJString("json"))
  if valid_579095 != nil:
    section.add "alt", valid_579095
  var valid_579096 = query.getOrDefault("uploadType")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "uploadType", valid_579096
  var valid_579097 = query.getOrDefault("quotaUser")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "quotaUser", valid_579097
  var valid_579098 = query.getOrDefault("callback")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "callback", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  var valid_579100 = query.getOrDefault("access_token")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "access_token", valid_579100
  var valid_579101 = query.getOrDefault("upload_protocol")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "upload_protocol", valid_579101
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

proc call*(call_579103: Call_ContaineranalysisProjectsOccurrencesCreate_579086;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ## 
  let valid = call_579103.validator(path, query, header, formData, body)
  let scheme = call_579103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579103.url(scheme.get, call_579103.host, call_579103.base,
                         call_579103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579103, url, valid)

proc call*(call_579104: Call_ContaineranalysisProjectsOccurrencesCreate_579086;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesCreate
  ## Creates a new `Occurrence`. Use this method to create `Occurrences`
  ## for a resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name of the project.  Should be of the form "projects/{project_id}".
  ## @Deprecated
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
  ##         : This field contains the project Id for example: "projects/{project_id}"
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579105 = newJObject()
  var query_579106 = newJObject()
  var body_579107 = newJObject()
  add(query_579106, "key", newJString(key))
  add(query_579106, "prettyPrint", newJBool(prettyPrint))
  add(query_579106, "oauth_token", newJString(oauthToken))
  add(query_579106, "name", newJString(name))
  add(query_579106, "$.xgafv", newJString(Xgafv))
  add(query_579106, "alt", newJString(alt))
  add(query_579106, "uploadType", newJString(uploadType))
  add(query_579106, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579107 = body
  add(query_579106, "callback", newJString(callback))
  add(path_579105, "parent", newJString(parent))
  add(query_579106, "fields", newJString(fields))
  add(query_579106, "access_token", newJString(accessToken))
  add(query_579106, "upload_protocol", newJString(uploadProtocol))
  result = call_579104.call(path_579105, query_579106, nil, nil, body_579107)

var containeranalysisProjectsOccurrencesCreate* = Call_ContaineranalysisProjectsOccurrencesCreate_579086(
    name: "containeranalysisProjectsOccurrencesCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesCreate_579087,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesCreate_579088,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesList_579062 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesList_579064(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/occurrences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesList_579063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579065 = path.getOrDefault("parent")
  valid_579065 = validateParameter(valid_579065, JString, required = true,
                                 default = nil)
  if valid_579065 != nil:
    section.add "parent", valid_579065
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of occurrences to return in the list.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: JString
  ##           : JSONP
  ##   kind: JString
  ##       : The kind of occurrences to filter on.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579066 = query.getOrDefault("key")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "key", valid_579066
  var valid_579067 = query.getOrDefault("prettyPrint")
  valid_579067 = validateParameter(valid_579067, JBool, required = false,
                                 default = newJBool(true))
  if valid_579067 != nil:
    section.add "prettyPrint", valid_579067
  var valid_579068 = query.getOrDefault("oauth_token")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "oauth_token", valid_579068
  var valid_579069 = query.getOrDefault("name")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "name", valid_579069
  var valid_579070 = query.getOrDefault("$.xgafv")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = newJString("1"))
  if valid_579070 != nil:
    section.add "$.xgafv", valid_579070
  var valid_579071 = query.getOrDefault("pageSize")
  valid_579071 = validateParameter(valid_579071, JInt, required = false, default = nil)
  if valid_579071 != nil:
    section.add "pageSize", valid_579071
  var valid_579072 = query.getOrDefault("alt")
  valid_579072 = validateParameter(valid_579072, JString, required = false,
                                 default = newJString("json"))
  if valid_579072 != nil:
    section.add "alt", valid_579072
  var valid_579073 = query.getOrDefault("uploadType")
  valid_579073 = validateParameter(valid_579073, JString, required = false,
                                 default = nil)
  if valid_579073 != nil:
    section.add "uploadType", valid_579073
  var valid_579074 = query.getOrDefault("quotaUser")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "quotaUser", valid_579074
  var valid_579075 = query.getOrDefault("filter")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "filter", valid_579075
  var valid_579076 = query.getOrDefault("pageToken")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "pageToken", valid_579076
  var valid_579077 = query.getOrDefault("callback")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "callback", valid_579077
  var valid_579078 = query.getOrDefault("kind")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("KIND_UNSPECIFIED"))
  if valid_579078 != nil:
    section.add "kind", valid_579078
  var valid_579079 = query.getOrDefault("fields")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "fields", valid_579079
  var valid_579080 = query.getOrDefault("access_token")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "access_token", valid_579080
  var valid_579081 = query.getOrDefault("upload_protocol")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "upload_protocol", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_ContaineranalysisProjectsOccurrencesList_579062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists active `Occurrences` for a given project matching the filters.
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_ContaineranalysisProjectsOccurrencesList_579062;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; name: string = ""; Xgafv: string = "1";
          pageSize: int = 0; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; filter: string = ""; pageToken: string = "";
          callback: string = ""; kind: string = "KIND_UNSPECIFIED"; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesList
  ## Lists active `Occurrences` for a given project matching the filters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string
  ##       : The name field contains the project Id. For example:
  ## "projects/{project_id}
  ## @Deprecated
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of occurrences to return in the list.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : Token to provide to skip to a particular spot in the list.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : This contains the project Id for example: projects/{project_id}.
  ##   kind: string
  ##       : The kind of occurrences to filter on.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "name", newJString(name))
  add(query_579085, "$.xgafv", newJString(Xgafv))
  add(query_579085, "pageSize", newJInt(pageSize))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "uploadType", newJString(uploadType))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(query_579085, "filter", newJString(filter))
  add(query_579085, "pageToken", newJString(pageToken))
  add(query_579085, "callback", newJString(callback))
  add(path_579084, "parent", newJString(parent))
  add(query_579085, "kind", newJString(kind))
  add(query_579085, "fields", newJString(fields))
  add(query_579085, "access_token", newJString(accessToken))
  add(query_579085, "upload_protocol", newJString(uploadProtocol))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var containeranalysisProjectsOccurrencesList* = Call_ContaineranalysisProjectsOccurrencesList_579062(
    name: "containeranalysisProjectsOccurrencesList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences",
    validator: validate_ContaineranalysisProjectsOccurrencesList_579063,
    base: "/", url: url_ContaineranalysisProjectsOccurrencesList_579064,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579108 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579110(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"), (kind: ConstantSegment,
        value: "/occurrences:vulnerabilitySummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579109(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This contains the project Id for example: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579111 = path.getOrDefault("parent")
  valid_579111 = validateParameter(valid_579111, JString, required = true,
                                 default = nil)
  if valid_579111 != nil:
    section.add "parent", valid_579111
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
  ##   filter: JString
  ##         : The filter expression.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("$.xgafv")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("1"))
  if valid_579115 != nil:
    section.add "$.xgafv", valid_579115
  var valid_579116 = query.getOrDefault("alt")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("json"))
  if valid_579116 != nil:
    section.add "alt", valid_579116
  var valid_579117 = query.getOrDefault("uploadType")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "uploadType", valid_579117
  var valid_579118 = query.getOrDefault("quotaUser")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "quotaUser", valid_579118
  var valid_579119 = query.getOrDefault("filter")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "filter", valid_579119
  var valid_579120 = query.getOrDefault("callback")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "callback", valid_579120
  var valid_579121 = query.getOrDefault("fields")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "fields", valid_579121
  var valid_579122 = query.getOrDefault("access_token")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "access_token", valid_579122
  var valid_579123 = query.getOrDefault("upload_protocol")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "upload_protocol", valid_579123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579124: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a summary of the number and severity of occurrences.
  ## 
  let valid = call_579124.validator(path, query, header, formData, body)
  let scheme = call_579124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579124.url(scheme.get, call_579124.host, call_579124.base,
                         call_579124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579124, url, valid)

proc call*(call_579125: Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579108;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOccurrencesGetVulnerabilitySummary
  ## Gets a summary of the number and severity of occurrences.
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
  ##   filter: string
  ##         : The filter expression.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : This contains the project Id for example: projects/{project_id}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579126 = newJObject()
  var query_579127 = newJObject()
  add(query_579127, "key", newJString(key))
  add(query_579127, "prettyPrint", newJBool(prettyPrint))
  add(query_579127, "oauth_token", newJString(oauthToken))
  add(query_579127, "$.xgafv", newJString(Xgafv))
  add(query_579127, "alt", newJString(alt))
  add(query_579127, "uploadType", newJString(uploadType))
  add(query_579127, "quotaUser", newJString(quotaUser))
  add(query_579127, "filter", newJString(filter))
  add(query_579127, "callback", newJString(callback))
  add(path_579126, "parent", newJString(parent))
  add(query_579127, "fields", newJString(fields))
  add(query_579127, "access_token", newJString(accessToken))
  add(query_579127, "upload_protocol", newJString(uploadProtocol))
  result = call_579125.call(path_579126, query_579127, nil, nil, nil)

var containeranalysisProjectsOccurrencesGetVulnerabilitySummary* = Call_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579108(
    name: "containeranalysisProjectsOccurrencesGetVulnerabilitySummary",
    meth: HttpMethod.HttpGet, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/occurrences:vulnerabilitySummary", validator: validate_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579109,
    base: "/",
    url: url_ContaineranalysisProjectsOccurrencesGetVulnerabilitySummary_579110,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsOperationsCreate_579128 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsOperationsCreate_579130(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsOperationsCreate_579129(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new `Operation`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The project Id that this operation should be created under.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579131 = path.getOrDefault("parent")
  valid_579131 = validateParameter(valid_579131, JString, required = true,
                                 default = nil)
  if valid_579131 != nil:
    section.add "parent", valid_579131
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
  var valid_579132 = query.getOrDefault("key")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "key", valid_579132
  var valid_579133 = query.getOrDefault("prettyPrint")
  valid_579133 = validateParameter(valid_579133, JBool, required = false,
                                 default = newJBool(true))
  if valid_579133 != nil:
    section.add "prettyPrint", valid_579133
  var valid_579134 = query.getOrDefault("oauth_token")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "oauth_token", valid_579134
  var valid_579135 = query.getOrDefault("$.xgafv")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = newJString("1"))
  if valid_579135 != nil:
    section.add "$.xgafv", valid_579135
  var valid_579136 = query.getOrDefault("alt")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("json"))
  if valid_579136 != nil:
    section.add "alt", valid_579136
  var valid_579137 = query.getOrDefault("uploadType")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "uploadType", valid_579137
  var valid_579138 = query.getOrDefault("quotaUser")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "quotaUser", valid_579138
  var valid_579139 = query.getOrDefault("callback")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "callback", valid_579139
  var valid_579140 = query.getOrDefault("fields")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "fields", valid_579140
  var valid_579141 = query.getOrDefault("access_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "access_token", valid_579141
  var valid_579142 = query.getOrDefault("upload_protocol")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "upload_protocol", valid_579142
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

proc call*(call_579144: Call_ContaineranalysisProjectsOperationsCreate_579128;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new `Operation`.
  ## 
  let valid = call_579144.validator(path, query, header, formData, body)
  let scheme = call_579144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579144.url(scheme.get, call_579144.host, call_579144.base,
                         call_579144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579144, url, valid)

proc call*(call_579145: Call_ContaineranalysisProjectsOperationsCreate_579128;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsOperationsCreate
  ## Creates a new `Operation`.
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
  ##         : The project Id that this operation should be created under.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579146 = newJObject()
  var query_579147 = newJObject()
  var body_579148 = newJObject()
  add(query_579147, "key", newJString(key))
  add(query_579147, "prettyPrint", newJBool(prettyPrint))
  add(query_579147, "oauth_token", newJString(oauthToken))
  add(query_579147, "$.xgafv", newJString(Xgafv))
  add(query_579147, "alt", newJString(alt))
  add(query_579147, "uploadType", newJString(uploadType))
  add(query_579147, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579148 = body
  add(query_579147, "callback", newJString(callback))
  add(path_579146, "parent", newJString(parent))
  add(query_579147, "fields", newJString(fields))
  add(query_579147, "access_token", newJString(accessToken))
  add(query_579147, "upload_protocol", newJString(uploadProtocol))
  result = call_579145.call(path_579146, query_579147, nil, nil, body_579148)

var containeranalysisProjectsOperationsCreate* = Call_ContaineranalysisProjectsOperationsCreate_579128(
    name: "containeranalysisProjectsOperationsCreate", meth: HttpMethod.HttpPost,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/operations",
    validator: validate_ContaineranalysisProjectsOperationsCreate_579129,
    base: "/", url: url_ContaineranalysisProjectsOperationsCreate_579130,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProjectsScanConfigsList_579149 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProjectsScanConfigsList_579151(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/scanConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProjectsScanConfigsList_579150(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists scan configurations for a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : This containers the project Id i.e.: projects/{project_id}
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579152 = path.getOrDefault("parent")
  valid_579152 = validateParameter(valid_579152, JString, required = true,
                                 default = nil)
  if valid_579152 != nil:
    section.add "parent", valid_579152
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
  ##           : The number of items to return.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The filter expression.
  ##   pageToken: JString
  ##            : The page token to use for the next request.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579153 = query.getOrDefault("key")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "key", valid_579153
  var valid_579154 = query.getOrDefault("prettyPrint")
  valid_579154 = validateParameter(valid_579154, JBool, required = false,
                                 default = newJBool(true))
  if valid_579154 != nil:
    section.add "prettyPrint", valid_579154
  var valid_579155 = query.getOrDefault("oauth_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "oauth_token", valid_579155
  var valid_579156 = query.getOrDefault("$.xgafv")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = newJString("1"))
  if valid_579156 != nil:
    section.add "$.xgafv", valid_579156
  var valid_579157 = query.getOrDefault("pageSize")
  valid_579157 = validateParameter(valid_579157, JInt, required = false, default = nil)
  if valid_579157 != nil:
    section.add "pageSize", valid_579157
  var valid_579158 = query.getOrDefault("alt")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = newJString("json"))
  if valid_579158 != nil:
    section.add "alt", valid_579158
  var valid_579159 = query.getOrDefault("uploadType")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "uploadType", valid_579159
  var valid_579160 = query.getOrDefault("quotaUser")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "quotaUser", valid_579160
  var valid_579161 = query.getOrDefault("filter")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "filter", valid_579161
  var valid_579162 = query.getOrDefault("pageToken")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "pageToken", valid_579162
  var valid_579163 = query.getOrDefault("callback")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "callback", valid_579163
  var valid_579164 = query.getOrDefault("fields")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "fields", valid_579164
  var valid_579165 = query.getOrDefault("access_token")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "access_token", valid_579165
  var valid_579166 = query.getOrDefault("upload_protocol")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "upload_protocol", valid_579166
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579167: Call_ContaineranalysisProjectsScanConfigsList_579149;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists scan configurations for a project.
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_ContaineranalysisProjectsScanConfigsList_579149;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## containeranalysisProjectsScanConfigsList
  ## Lists scan configurations for a project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The number of items to return.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: string
  ##         : The filter expression.
  ##   pageToken: string
  ##            : The page token to use for the next request.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : This containers the project Id i.e.: projects/{project_id}
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579169 = newJObject()
  var query_579170 = newJObject()
  add(query_579170, "key", newJString(key))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(query_579170, "$.xgafv", newJString(Xgafv))
  add(query_579170, "pageSize", newJInt(pageSize))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "uploadType", newJString(uploadType))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(query_579170, "filter", newJString(filter))
  add(query_579170, "pageToken", newJString(pageToken))
  add(query_579170, "callback", newJString(callback))
  add(path_579169, "parent", newJString(parent))
  add(query_579170, "fields", newJString(fields))
  add(query_579170, "access_token", newJString(accessToken))
  add(query_579170, "upload_protocol", newJString(uploadProtocol))
  result = call_579168.call(path_579169, query_579170, nil, nil, nil)

var containeranalysisProjectsScanConfigsList* = Call_ContaineranalysisProjectsScanConfigsList_579149(
    name: "containeranalysisProjectsScanConfigsList", meth: HttpMethod.HttpGet,
    host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{parent}/scanConfigs",
    validator: validate_ContaineranalysisProjectsScanConfigsList_579150,
    base: "/", url: url_ContaineranalysisProjectsScanConfigsList_579151,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesGetIamPolicy_579171 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesGetIamPolicy_579173(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesGetIamPolicy_579172(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579174 = path.getOrDefault("resource")
  valid_579174 = validateParameter(valid_579174, JString, required = true,
                                 default = nil)
  if valid_579174 != nil:
    section.add "resource", valid_579174
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
  var valid_579175 = query.getOrDefault("key")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "key", valid_579175
  var valid_579176 = query.getOrDefault("prettyPrint")
  valid_579176 = validateParameter(valid_579176, JBool, required = false,
                                 default = newJBool(true))
  if valid_579176 != nil:
    section.add "prettyPrint", valid_579176
  var valid_579177 = query.getOrDefault("oauth_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "oauth_token", valid_579177
  var valid_579178 = query.getOrDefault("$.xgafv")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = newJString("1"))
  if valid_579178 != nil:
    section.add "$.xgafv", valid_579178
  var valid_579179 = query.getOrDefault("alt")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = newJString("json"))
  if valid_579179 != nil:
    section.add "alt", valid_579179
  var valid_579180 = query.getOrDefault("uploadType")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "uploadType", valid_579180
  var valid_579181 = query.getOrDefault("quotaUser")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "quotaUser", valid_579181
  var valid_579182 = query.getOrDefault("callback")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "callback", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  var valid_579184 = query.getOrDefault("access_token")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "access_token", valid_579184
  var valid_579185 = query.getOrDefault("upload_protocol")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "upload_protocol", valid_579185
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

proc call*(call_579187: Call_ContaineranalysisProvidersNotesGetIamPolicy_579171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_ContaineranalysisProvidersNotesGetIamPolicy_579171;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesGetIamPolicy
  ## Gets the access control policy for a note or an `Occurrence` resource.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a note or occurrence, respectively.
  ## Attempting to call this method on a resource without the required
  ## permission will result in a `PERMISSION_DENIED` error. Attempting to call
  ## this method on a non-existent resource will result in a `NOT_FOUND` error
  ## if the user has list permission on the project, or a `PERMISSION_DENIED`
  ## error otherwise. The resource takes the following formats:
  ## `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for occurrences and
  ## projects/{PROJECT_ID}/notes/{NOTE_ID} for notes
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  var body_579191 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(query_579190, "$.xgafv", newJString(Xgafv))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "uploadType", newJString(uploadType))
  add(query_579190, "quotaUser", newJString(quotaUser))
  add(path_579189, "resource", newJString(resource))
  if body != nil:
    body_579191 = body
  add(query_579190, "callback", newJString(callback))
  add(query_579190, "fields", newJString(fields))
  add(query_579190, "access_token", newJString(accessToken))
  add(query_579190, "upload_protocol", newJString(uploadProtocol))
  result = call_579188.call(path_579189, query_579190, nil, nil, body_579191)

var containeranalysisProvidersNotesGetIamPolicy* = Call_ContaineranalysisProvidersNotesGetIamPolicy_579171(
    name: "containeranalysisProvidersNotesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:getIamPolicy",
    validator: validate_ContaineranalysisProvidersNotesGetIamPolicy_579172,
    base: "/", url: url_ContaineranalysisProvidersNotesGetIamPolicy_579173,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesSetIamPolicy_579192 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesSetIamPolicy_579194(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesSetIamPolicy_579193(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579195 = path.getOrDefault("resource")
  valid_579195 = validateParameter(valid_579195, JString, required = true,
                                 default = nil)
  if valid_579195 != nil:
    section.add "resource", valid_579195
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
  var valid_579196 = query.getOrDefault("key")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "key", valid_579196
  var valid_579197 = query.getOrDefault("prettyPrint")
  valid_579197 = validateParameter(valid_579197, JBool, required = false,
                                 default = newJBool(true))
  if valid_579197 != nil:
    section.add "prettyPrint", valid_579197
  var valid_579198 = query.getOrDefault("oauth_token")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "oauth_token", valid_579198
  var valid_579199 = query.getOrDefault("$.xgafv")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = newJString("1"))
  if valid_579199 != nil:
    section.add "$.xgafv", valid_579199
  var valid_579200 = query.getOrDefault("alt")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = newJString("json"))
  if valid_579200 != nil:
    section.add "alt", valid_579200
  var valid_579201 = query.getOrDefault("uploadType")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "uploadType", valid_579201
  var valid_579202 = query.getOrDefault("quotaUser")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = nil)
  if valid_579202 != nil:
    section.add "quotaUser", valid_579202
  var valid_579203 = query.getOrDefault("callback")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = nil)
  if valid_579203 != nil:
    section.add "callback", valid_579203
  var valid_579204 = query.getOrDefault("fields")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "fields", valid_579204
  var valid_579205 = query.getOrDefault("access_token")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "access_token", valid_579205
  var valid_579206 = query.getOrDefault("upload_protocol")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "upload_protocol", valid_579206
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

proc call*(call_579208: Call_ContaineranalysisProvidersNotesSetIamPolicy_579192;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
  ## 
  let valid = call_579208.validator(path, query, header, formData, body)
  let scheme = call_579208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579208.url(scheme.get, call_579208.host, call_579208.base,
                         call_579208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579208, url, valid)

proc call*(call_579209: Call_ContaineranalysisProvidersNotesSetIamPolicy_579192;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesSetIamPolicy
  ## Sets the access control policy on the specified `Note` or `Occurrence`.
  ## Requires `containeranalysis.notes.setIamPolicy` or
  ## `containeranalysis.occurrences.setIamPolicy` permission if the resource is
  ## a `Note` or an `Occurrence`, respectively.
  ## Attempting to call this method without these permissions will result in a `
  ## `PERMISSION_DENIED` error.
  ## Attempting to call this method on a non-existent resource will result in a
  ## `NOT_FOUND` error if the user has `containeranalysis.notes.list` permission
  ## on a `Note` or `containeranalysis.occurrences.list` on an `Occurrence`, or
  ## a `PERMISSION_DENIED` error otherwise. The resource takes the following
  ## formats: `projects/{projectid}/occurrences/{occurrenceid}` for occurrences
  ## and projects/{projectid}/notes/{noteid} for notes
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579210 = newJObject()
  var query_579211 = newJObject()
  var body_579212 = newJObject()
  add(query_579211, "key", newJString(key))
  add(query_579211, "prettyPrint", newJBool(prettyPrint))
  add(query_579211, "oauth_token", newJString(oauthToken))
  add(query_579211, "$.xgafv", newJString(Xgafv))
  add(query_579211, "alt", newJString(alt))
  add(query_579211, "uploadType", newJString(uploadType))
  add(query_579211, "quotaUser", newJString(quotaUser))
  add(path_579210, "resource", newJString(resource))
  if body != nil:
    body_579212 = body
  add(query_579211, "callback", newJString(callback))
  add(query_579211, "fields", newJString(fields))
  add(query_579211, "access_token", newJString(accessToken))
  add(query_579211, "upload_protocol", newJString(uploadProtocol))
  result = call_579209.call(path_579210, query_579211, nil, nil, body_579212)

var containeranalysisProvidersNotesSetIamPolicy* = Call_ContaineranalysisProvidersNotesSetIamPolicy_579192(
    name: "containeranalysisProvidersNotesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:setIamPolicy",
    validator: validate_ContaineranalysisProvidersNotesSetIamPolicy_579193,
    base: "/", url: url_ContaineranalysisProvidersNotesSetIamPolicy_579194,
    schemes: {Scheme.Https})
type
  Call_ContaineranalysisProvidersNotesTestIamPermissions_579213 = ref object of OpenApiRestCall_578348
proc url_ContaineranalysisProvidersNotesTestIamPermissions_579215(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ContaineranalysisProvidersNotesTestIamPermissions_579214(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579216 = path.getOrDefault("resource")
  valid_579216 = validateParameter(valid_579216, JString, required = true,
                                 default = nil)
  if valid_579216 != nil:
    section.add "resource", valid_579216
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
  var valid_579217 = query.getOrDefault("key")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "key", valid_579217
  var valid_579218 = query.getOrDefault("prettyPrint")
  valid_579218 = validateParameter(valid_579218, JBool, required = false,
                                 default = newJBool(true))
  if valid_579218 != nil:
    section.add "prettyPrint", valid_579218
  var valid_579219 = query.getOrDefault("oauth_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "oauth_token", valid_579219
  var valid_579220 = query.getOrDefault("$.xgafv")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = newJString("1"))
  if valid_579220 != nil:
    section.add "$.xgafv", valid_579220
  var valid_579221 = query.getOrDefault("alt")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = newJString("json"))
  if valid_579221 != nil:
    section.add "alt", valid_579221
  var valid_579222 = query.getOrDefault("uploadType")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "uploadType", valid_579222
  var valid_579223 = query.getOrDefault("quotaUser")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = nil)
  if valid_579223 != nil:
    section.add "quotaUser", valid_579223
  var valid_579224 = query.getOrDefault("callback")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = nil)
  if valid_579224 != nil:
    section.add "callback", valid_579224
  var valid_579225 = query.getOrDefault("fields")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "fields", valid_579225
  var valid_579226 = query.getOrDefault("access_token")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "access_token", valid_579226
  var valid_579227 = query.getOrDefault("upload_protocol")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "upload_protocol", valid_579227
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

proc call*(call_579229: Call_ContaineranalysisProvidersNotesTestIamPermissions_579213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
  ## 
  let valid = call_579229.validator(path, query, header, formData, body)
  let scheme = call_579229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579229.url(scheme.get, call_579229.host, call_579229.base,
                         call_579229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579229, url, valid)

proc call*(call_579230: Call_ContaineranalysisProvidersNotesTestIamPermissions_579213;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## containeranalysisProvidersNotesTestIamPermissions
  ## Returns the permissions that a caller has on the specified note or
  ## occurrence resource. Requires list permission on the project (for example,
  ## "storage.objects.list" on the containing bucket for testing permission of
  ## an object). Attempting to call this method on a non-existent resource will
  ## result in a `NOT_FOUND` error if the user has list permission on the
  ## project, or a `PERMISSION_DENIED` error otherwise. The resource takes the
  ## following formats: `projects/{PROJECT_ID}/occurrences/{OCCURRENCE_ID}` for
  ## `Occurrences` and `projects/{PROJECT_ID}/notes/{NOTE_ID}` for `Notes`
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
  ##   resource: string (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579231 = newJObject()
  var query_579232 = newJObject()
  var body_579233 = newJObject()
  add(query_579232, "key", newJString(key))
  add(query_579232, "prettyPrint", newJBool(prettyPrint))
  add(query_579232, "oauth_token", newJString(oauthToken))
  add(query_579232, "$.xgafv", newJString(Xgafv))
  add(query_579232, "alt", newJString(alt))
  add(query_579232, "uploadType", newJString(uploadType))
  add(query_579232, "quotaUser", newJString(quotaUser))
  add(path_579231, "resource", newJString(resource))
  if body != nil:
    body_579233 = body
  add(query_579232, "callback", newJString(callback))
  add(query_579232, "fields", newJString(fields))
  add(query_579232, "access_token", newJString(accessToken))
  add(query_579232, "upload_protocol", newJString(uploadProtocol))
  result = call_579230.call(path_579231, query_579232, nil, nil, body_579233)

var containeranalysisProvidersNotesTestIamPermissions* = Call_ContaineranalysisProvidersNotesTestIamPermissions_579213(
    name: "containeranalysisProvidersNotesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "containeranalysis.googleapis.com",
    route: "/v1alpha1/{resource}:testIamPermissions",
    validator: validate_ContaineranalysisProvidersNotesTestIamPermissions_579214,
    base: "/", url: url_ContaineranalysisProvidersNotesTestIamPermissions_579215,
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
