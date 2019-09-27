
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Knowledge Graph Search
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Searches the Google Knowledge Graph for entities.
## 
## https://developers.google.com/knowledge-graph/
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  gcpServiceName = "kgsearch"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_KgsearchEntitiesSearch_593677 = ref object of OpenApiRestCall_593408
proc url_KgsearchEntitiesSearch_593679(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_KgsearchEntitiesSearch_593678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   languages: JArray
  ##            : The list of language codes (defined in ISO 693) to run the query with,
  ## e.g. 'en'.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : The literal query string for search.
  ##   types: JArray
  ##        : Restricts returned entities with these types, e.g. Person
  ## (as defined in http://schema.org/Person). If multiple types are specified,
  ## returned entities will contain one or more of these types.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   indent: JBool
  ##         : Enables indenting of json results.
  ##   ids: JArray
  ##      : The list of entity id to be used for search instead of query string.
  ## To specify multiple ids in the HTTP request, repeat the parameter in the
  ## URL as in ...?ids=A&ids=B
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JBool
  ##         : Enables prefix match against names and aliases of entities
  ##   limit: JInt
  ##        : Limits the number of entities to be returned.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("languages")
  valid_593793 = validateParameter(valid_593793, JArray, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "languages", valid_593793
  var valid_593794 = query.getOrDefault("quotaUser")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "quotaUser", valid_593794
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("query")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "query", valid_593809
  var valid_593810 = query.getOrDefault("types")
  valid_593810 = validateParameter(valid_593810, JArray, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "types", valid_593810
  var valid_593811 = query.getOrDefault("oauth_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "oauth_token", valid_593811
  var valid_593812 = query.getOrDefault("callback")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "callback", valid_593812
  var valid_593813 = query.getOrDefault("access_token")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "access_token", valid_593813
  var valid_593814 = query.getOrDefault("uploadType")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "uploadType", valid_593814
  var valid_593815 = query.getOrDefault("indent")
  valid_593815 = validateParameter(valid_593815, JBool, required = false, default = nil)
  if valid_593815 != nil:
    section.add "indent", valid_593815
  var valid_593816 = query.getOrDefault("ids")
  valid_593816 = validateParameter(valid_593816, JArray, required = false,
                                 default = nil)
  if valid_593816 != nil:
    section.add "ids", valid_593816
  var valid_593817 = query.getOrDefault("key")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "key", valid_593817
  var valid_593818 = query.getOrDefault("$.xgafv")
  valid_593818 = validateParameter(valid_593818, JString, required = false,
                                 default = newJString("1"))
  if valid_593818 != nil:
    section.add "$.xgafv", valid_593818
  var valid_593819 = query.getOrDefault("prettyPrint")
  valid_593819 = validateParameter(valid_593819, JBool, required = false,
                                 default = newJBool(true))
  if valid_593819 != nil:
    section.add "prettyPrint", valid_593819
  var valid_593820 = query.getOrDefault("prefix")
  valid_593820 = validateParameter(valid_593820, JBool, required = false, default = nil)
  if valid_593820 != nil:
    section.add "prefix", valid_593820
  var valid_593821 = query.getOrDefault("limit")
  valid_593821 = validateParameter(valid_593821, JInt, required = false, default = nil)
  if valid_593821 != nil:
    section.add "limit", valid_593821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593844: Call_KgsearchEntitiesSearch_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ## 
  let valid = call_593844.validator(path, query, header, formData, body)
  let scheme = call_593844.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593844.url(scheme.get, call_593844.host, call_593844.base,
                         call_593844.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593844, url, valid)

proc call*(call_593915: Call_KgsearchEntitiesSearch_593677;
          uploadProtocol: string = ""; fields: string = ""; languages: JsonNode = nil;
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          types: JsonNode = nil; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; indent: bool = false;
          ids: JsonNode = nil; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true; prefix: bool = false; limit: int = 0): Recallable =
  ## kgsearchEntitiesSearch
  ## Searches Knowledge Graph for entities that match the constraints.
  ## A list of matched entities will be returned in response, which will be in
  ## JSON-LD format and compatible with http://schema.org
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   languages: JArray
  ##            : The list of language codes (defined in ISO 693) to run the query with,
  ## e.g. 'en'.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : The literal query string for search.
  ##   types: JArray
  ##        : Restricts returned entities with these types, e.g. Person
  ## (as defined in http://schema.org/Person). If multiple types are specified,
  ## returned entities will contain one or more of these types.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   indent: bool
  ##         : Enables indenting of json results.
  ##   ids: JArray
  ##      : The list of entity id to be used for search instead of query string.
  ## To specify multiple ids in the HTTP request, repeat the parameter in the
  ## URL as in ...?ids=A&ids=B
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: bool
  ##         : Enables prefix match against names and aliases of entities
  ##   limit: int
  ##        : Limits the number of entities to be returned.
  var query_593916 = newJObject()
  add(query_593916, "upload_protocol", newJString(uploadProtocol))
  add(query_593916, "fields", newJString(fields))
  if languages != nil:
    query_593916.add "languages", languages
  add(query_593916, "quotaUser", newJString(quotaUser))
  add(query_593916, "alt", newJString(alt))
  add(query_593916, "query", newJString(query))
  if types != nil:
    query_593916.add "types", types
  add(query_593916, "oauth_token", newJString(oauthToken))
  add(query_593916, "callback", newJString(callback))
  add(query_593916, "access_token", newJString(accessToken))
  add(query_593916, "uploadType", newJString(uploadType))
  add(query_593916, "indent", newJBool(indent))
  if ids != nil:
    query_593916.add "ids", ids
  add(query_593916, "key", newJString(key))
  add(query_593916, "$.xgafv", newJString(Xgafv))
  add(query_593916, "prettyPrint", newJBool(prettyPrint))
  add(query_593916, "prefix", newJBool(prefix))
  add(query_593916, "limit", newJInt(limit))
  result = call_593915.call(nil, query_593916, nil, nil, nil)

var kgsearchEntitiesSearch* = Call_KgsearchEntitiesSearch_593677(
    name: "kgsearchEntitiesSearch", meth: HttpMethod.HttpGet,
    host: "kgsearch.googleapis.com", route: "/v1/entities:search",
    validator: validate_KgsearchEntitiesSearch_593678, base: "/",
    url: url_KgsearchEntitiesSearch_593679, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
