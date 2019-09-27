
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Blogger
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for access to the data within Blogger.
## 
## https://developers.google.com/blogger/docs/2.0/json/getting_started
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "blogger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGet_597676 = ref object of OpenApiRestCall_597408
proc url_BloggerBlogsGet_597678(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogsGet_597677(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : The ID of the blog to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_597804 = path.getOrDefault("blogId")
  valid_597804 = validateParameter(valid_597804, JString, required = true,
                                 default = nil)
  if valid_597804 != nil:
    section.add "blogId", valid_597804
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
  var valid_597805 = query.getOrDefault("fields")
  valid_597805 = validateParameter(valid_597805, JString, required = false,
                                 default = nil)
  if valid_597805 != nil:
    section.add "fields", valid_597805
  var valid_597806 = query.getOrDefault("quotaUser")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "quotaUser", valid_597806
  var valid_597820 = query.getOrDefault("alt")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = newJString("json"))
  if valid_597820 != nil:
    section.add "alt", valid_597820
  var valid_597821 = query.getOrDefault("oauth_token")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "oauth_token", valid_597821
  var valid_597822 = query.getOrDefault("userIp")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = nil)
  if valid_597822 != nil:
    section.add "userIp", valid_597822
  var valid_597823 = query.getOrDefault("key")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "key", valid_597823
  var valid_597824 = query.getOrDefault("prettyPrint")
  valid_597824 = validateParameter(valid_597824, JBool, required = false,
                                 default = newJBool(true))
  if valid_597824 != nil:
    section.add "prettyPrint", valid_597824
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597847: Call_BloggerBlogsGet_597676; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by id.
  ## 
  let valid = call_597847.validator(path, query, header, formData, body)
  let scheme = call_597847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597847.url(scheme.get, call_597847.host, call_597847.base,
                         call_597847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597847, url, valid)

proc call*(call_597918: Call_BloggerBlogsGet_597676; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerBlogsGet
  ## Gets one blog by id.
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
  ##   blogId: string (required)
  ##         : The ID of the blog to get.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597919 = newJObject()
  var query_597921 = newJObject()
  add(query_597921, "fields", newJString(fields))
  add(query_597921, "quotaUser", newJString(quotaUser))
  add(query_597921, "alt", newJString(alt))
  add(query_597921, "oauth_token", newJString(oauthToken))
  add(query_597921, "userIp", newJString(userIp))
  add(query_597921, "key", newJString(key))
  add(path_597919, "blogId", newJString(blogId))
  add(query_597921, "prettyPrint", newJBool(prettyPrint))
  result = call_597918.call(path_597919, query_597921, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_597676(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_597677, base: "/blogger/v2",
    url: url_BloggerBlogsGet_597678, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_597960 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesList_597962(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesList_597961(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves pages for a blog, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch pages from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_597963 = path.getOrDefault("blogId")
  valid_597963 = validateParameter(valid_597963, JString, required = true,
                                 default = nil)
  if valid_597963 != nil:
    section.add "blogId", valid_597963
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
  ##   fetchBodies: JBool
  ##              : Whether to retrieve the Page bodies.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597964 = query.getOrDefault("fields")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = nil)
  if valid_597964 != nil:
    section.add "fields", valid_597964
  var valid_597965 = query.getOrDefault("quotaUser")
  valid_597965 = validateParameter(valid_597965, JString, required = false,
                                 default = nil)
  if valid_597965 != nil:
    section.add "quotaUser", valid_597965
  var valid_597966 = query.getOrDefault("alt")
  valid_597966 = validateParameter(valid_597966, JString, required = false,
                                 default = newJString("json"))
  if valid_597966 != nil:
    section.add "alt", valid_597966
  var valid_597967 = query.getOrDefault("oauth_token")
  valid_597967 = validateParameter(valid_597967, JString, required = false,
                                 default = nil)
  if valid_597967 != nil:
    section.add "oauth_token", valid_597967
  var valid_597968 = query.getOrDefault("userIp")
  valid_597968 = validateParameter(valid_597968, JString, required = false,
                                 default = nil)
  if valid_597968 != nil:
    section.add "userIp", valid_597968
  var valid_597969 = query.getOrDefault("key")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "key", valid_597969
  var valid_597970 = query.getOrDefault("fetchBodies")
  valid_597970 = validateParameter(valid_597970, JBool, required = false, default = nil)
  if valid_597970 != nil:
    section.add "fetchBodies", valid_597970
  var valid_597971 = query.getOrDefault("prettyPrint")
  valid_597971 = validateParameter(valid_597971, JBool, required = false,
                                 default = newJBool(true))
  if valid_597971 != nil:
    section.add "prettyPrint", valid_597971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597972: Call_BloggerPagesList_597960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves pages for a blog, possibly filtered.
  ## 
  let valid = call_597972.validator(path, query, header, formData, body)
  let scheme = call_597972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597972.url(scheme.get, call_597972.host, call_597972.base,
                         call_597972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597972, url, valid)

proc call*(call_597973: Call_BloggerPagesList_597960; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          fetchBodies: bool = false; prettyPrint: bool = true): Recallable =
  ## bloggerPagesList
  ## Retrieves pages for a blog, possibly filtered.
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
  ##   fetchBodies: bool
  ##              : Whether to retrieve the Page bodies.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch pages from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597974 = newJObject()
  var query_597975 = newJObject()
  add(query_597975, "fields", newJString(fields))
  add(query_597975, "quotaUser", newJString(quotaUser))
  add(query_597975, "alt", newJString(alt))
  add(query_597975, "oauth_token", newJString(oauthToken))
  add(query_597975, "userIp", newJString(userIp))
  add(query_597975, "key", newJString(key))
  add(query_597975, "fetchBodies", newJBool(fetchBodies))
  add(path_597974, "blogId", newJString(blogId))
  add(query_597975, "prettyPrint", newJBool(prettyPrint))
  result = call_597973.call(path_597974, query_597975, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_597960(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_597961,
    base: "/blogger/v2", url: url_BloggerPagesList_597962, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_597976 = ref object of OpenApiRestCall_597408
proc url_BloggerPagesGet_597978(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPagesGet_597977(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one blog page by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pageId: JString (required)
  ##         : The ID of the page to get.
  ##   blogId: JString (required)
  ##         : ID of the blog containing the page.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `pageId` field"
  var valid_597979 = path.getOrDefault("pageId")
  valid_597979 = validateParameter(valid_597979, JString, required = true,
                                 default = nil)
  if valid_597979 != nil:
    section.add "pageId", valid_597979
  var valid_597980 = path.getOrDefault("blogId")
  valid_597980 = validateParameter(valid_597980, JString, required = true,
                                 default = nil)
  if valid_597980 != nil:
    section.add "blogId", valid_597980
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
  var valid_597981 = query.getOrDefault("fields")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "fields", valid_597981
  var valid_597982 = query.getOrDefault("quotaUser")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "quotaUser", valid_597982
  var valid_597983 = query.getOrDefault("alt")
  valid_597983 = validateParameter(valid_597983, JString, required = false,
                                 default = newJString("json"))
  if valid_597983 != nil:
    section.add "alt", valid_597983
  var valid_597984 = query.getOrDefault("oauth_token")
  valid_597984 = validateParameter(valid_597984, JString, required = false,
                                 default = nil)
  if valid_597984 != nil:
    section.add "oauth_token", valid_597984
  var valid_597985 = query.getOrDefault("userIp")
  valid_597985 = validateParameter(valid_597985, JString, required = false,
                                 default = nil)
  if valid_597985 != nil:
    section.add "userIp", valid_597985
  var valid_597986 = query.getOrDefault("key")
  valid_597986 = validateParameter(valid_597986, JString, required = false,
                                 default = nil)
  if valid_597986 != nil:
    section.add "key", valid_597986
  var valid_597987 = query.getOrDefault("prettyPrint")
  valid_597987 = validateParameter(valid_597987, JBool, required = false,
                                 default = newJBool(true))
  if valid_597987 != nil:
    section.add "prettyPrint", valid_597987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597988: Call_BloggerPagesGet_597976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by id.
  ## 
  let valid = call_597988.validator(path, query, header, formData, body)
  let scheme = call_597988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597988.url(scheme.get, call_597988.host, call_597988.base,
                         call_597988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597988, url, valid)

proc call*(call_597989: Call_BloggerPagesGet_597976; pageId: string; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerPagesGet
  ## Gets one blog page by id.
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
  ##   pageId: string (required)
  ##         : The ID of the page to get.
  ##   blogId: string (required)
  ##         : ID of the blog containing the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_597990 = newJObject()
  var query_597991 = newJObject()
  add(query_597991, "fields", newJString(fields))
  add(query_597991, "quotaUser", newJString(quotaUser))
  add(query_597991, "alt", newJString(alt))
  add(query_597991, "oauth_token", newJString(oauthToken))
  add(query_597991, "userIp", newJString(userIp))
  add(query_597991, "key", newJString(key))
  add(path_597990, "pageId", newJString(pageId))
  add(path_597990, "blogId", newJString(blogId))
  add(query_597991, "prettyPrint", newJBool(prettyPrint))
  result = call_597989.call(path_597990, query_597991, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_597976(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_597977,
    base: "/blogger/v2", url: url_BloggerPagesGet_597978, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_597992 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsList_597994(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsList_597993(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch posts from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `blogId` field"
  var valid_597995 = path.getOrDefault("blogId")
  valid_597995 = validateParameter(valid_597995, JString, required = true,
                                 default = nil)
  if valid_597995 != nil:
    section.add "blogId", valid_597995
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if the request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   startDate: JString
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of posts to fetch.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fetchBodies: JBool
  ##              : Whether the body content of posts is included.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597996 = query.getOrDefault("fields")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "fields", valid_597996
  var valid_597997 = query.getOrDefault("pageToken")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "pageToken", valid_597997
  var valid_597998 = query.getOrDefault("quotaUser")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "quotaUser", valid_597998
  var valid_597999 = query.getOrDefault("alt")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = newJString("json"))
  if valid_597999 != nil:
    section.add "alt", valid_597999
  var valid_598000 = query.getOrDefault("startDate")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "startDate", valid_598000
  var valid_598001 = query.getOrDefault("oauth_token")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = nil)
  if valid_598001 != nil:
    section.add "oauth_token", valid_598001
  var valid_598002 = query.getOrDefault("userIp")
  valid_598002 = validateParameter(valid_598002, JString, required = false,
                                 default = nil)
  if valid_598002 != nil:
    section.add "userIp", valid_598002
  var valid_598003 = query.getOrDefault("maxResults")
  valid_598003 = validateParameter(valid_598003, JInt, required = false, default = nil)
  if valid_598003 != nil:
    section.add "maxResults", valid_598003
  var valid_598004 = query.getOrDefault("key")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "key", valid_598004
  var valid_598005 = query.getOrDefault("fetchBodies")
  valid_598005 = validateParameter(valid_598005, JBool, required = false, default = nil)
  if valid_598005 != nil:
    section.add "fetchBodies", valid_598005
  var valid_598006 = query.getOrDefault("prettyPrint")
  valid_598006 = validateParameter(valid_598006, JBool, required = false,
                                 default = newJBool(true))
  if valid_598006 != nil:
    section.add "prettyPrint", valid_598006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598007: Call_BloggerPostsList_597992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_598007.validator(path, query, header, formData, body)
  let scheme = call_598007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598007.url(scheme.get, call_598007.host, call_598007.base,
                         call_598007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598007, url, valid)

proc call*(call_598008: Call_BloggerPostsList_597992; blogId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; startDate: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          fetchBodies: bool = false; prettyPrint: bool = true): Recallable =
  ## bloggerPostsList
  ## Retrieves a list of posts, possibly filtered.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if the request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   startDate: string
  ##            : Earliest post date to fetch, a date-time with RFC 3339 formatting.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of posts to fetch.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fetchBodies: bool
  ##              : Whether the body content of posts is included.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch posts from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598009 = newJObject()
  var query_598010 = newJObject()
  add(query_598010, "fields", newJString(fields))
  add(query_598010, "pageToken", newJString(pageToken))
  add(query_598010, "quotaUser", newJString(quotaUser))
  add(query_598010, "alt", newJString(alt))
  add(query_598010, "startDate", newJString(startDate))
  add(query_598010, "oauth_token", newJString(oauthToken))
  add(query_598010, "userIp", newJString(userIp))
  add(query_598010, "maxResults", newJInt(maxResults))
  add(query_598010, "key", newJString(key))
  add(query_598010, "fetchBodies", newJBool(fetchBodies))
  add(path_598009, "blogId", newJString(blogId))
  add(query_598010, "prettyPrint", newJBool(prettyPrint))
  result = call_598008.call(path_598009, query_598010, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_597992(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_597993,
    base: "/blogger/v2", url: url_BloggerPostsList_597994, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_598011 = ref object of OpenApiRestCall_597408
proc url_BloggerPostsGet_598013(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerPostsGet_598012(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get a post by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : The ID of the post
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch the post from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_598014 = path.getOrDefault("postId")
  valid_598014 = validateParameter(valid_598014, JString, required = true,
                                 default = nil)
  if valid_598014 != nil:
    section.add "postId", valid_598014
  var valid_598015 = path.getOrDefault("blogId")
  valid_598015 = validateParameter(valid_598015, JString, required = true,
                                 default = nil)
  if valid_598015 != nil:
    section.add "blogId", valid_598015
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
  var valid_598016 = query.getOrDefault("fields")
  valid_598016 = validateParameter(valid_598016, JString, required = false,
                                 default = nil)
  if valid_598016 != nil:
    section.add "fields", valid_598016
  var valid_598017 = query.getOrDefault("quotaUser")
  valid_598017 = validateParameter(valid_598017, JString, required = false,
                                 default = nil)
  if valid_598017 != nil:
    section.add "quotaUser", valid_598017
  var valid_598018 = query.getOrDefault("alt")
  valid_598018 = validateParameter(valid_598018, JString, required = false,
                                 default = newJString("json"))
  if valid_598018 != nil:
    section.add "alt", valid_598018
  var valid_598019 = query.getOrDefault("oauth_token")
  valid_598019 = validateParameter(valid_598019, JString, required = false,
                                 default = nil)
  if valid_598019 != nil:
    section.add "oauth_token", valid_598019
  var valid_598020 = query.getOrDefault("userIp")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "userIp", valid_598020
  var valid_598021 = query.getOrDefault("key")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "key", valid_598021
  var valid_598022 = query.getOrDefault("prettyPrint")
  valid_598022 = validateParameter(valid_598022, JBool, required = false,
                                 default = newJBool(true))
  if valid_598022 != nil:
    section.add "prettyPrint", valid_598022
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598023: Call_BloggerPostsGet_598011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by id.
  ## 
  let valid = call_598023.validator(path, query, header, formData, body)
  let scheme = call_598023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598023.url(scheme.get, call_598023.host, call_598023.base,
                         call_598023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598023, url, valid)

proc call*(call_598024: Call_BloggerPostsGet_598011; postId: string; blogId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerPostsGet
  ## Get a post by id.
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
  ##   postId: string (required)
  ##         : The ID of the post
  ##   blogId: string (required)
  ##         : ID of the blog to fetch the post from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598025 = newJObject()
  var query_598026 = newJObject()
  add(query_598026, "fields", newJString(fields))
  add(query_598026, "quotaUser", newJString(quotaUser))
  add(query_598026, "alt", newJString(alt))
  add(query_598026, "oauth_token", newJString(oauthToken))
  add(query_598026, "userIp", newJString(userIp))
  add(query_598026, "key", newJString(key))
  add(path_598025, "postId", newJString(postId))
  add(path_598025, "blogId", newJString(blogId))
  add(query_598026, "prettyPrint", newJBool(prettyPrint))
  result = call_598024.call(path_598025, query_598026, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_598011(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_598012,
    base: "/blogger/v2", url: url_BloggerPostsGet_598013, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_598027 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsList_598029(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsList_598028(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves the comments for a blog, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: JString (required)
  ##         : ID of the blog to fetch comments from.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `postId` field"
  var valid_598030 = path.getOrDefault("postId")
  valid_598030 = validateParameter(valid_598030, JString, required = true,
                                 default = nil)
  if valid_598030 != nil:
    section.add "postId", valid_598030
  var valid_598031 = path.getOrDefault("blogId")
  valid_598031 = validateParameter(valid_598031, JString, required = true,
                                 default = nil)
  if valid_598031 != nil:
    section.add "blogId", valid_598031
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token if request is paged.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   startDate: JString
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of comments to include in the result.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   fetchBodies: JBool
  ##              : Whether the body content of the comments is included.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598032 = query.getOrDefault("fields")
  valid_598032 = validateParameter(valid_598032, JString, required = false,
                                 default = nil)
  if valid_598032 != nil:
    section.add "fields", valid_598032
  var valid_598033 = query.getOrDefault("pageToken")
  valid_598033 = validateParameter(valid_598033, JString, required = false,
                                 default = nil)
  if valid_598033 != nil:
    section.add "pageToken", valid_598033
  var valid_598034 = query.getOrDefault("quotaUser")
  valid_598034 = validateParameter(valid_598034, JString, required = false,
                                 default = nil)
  if valid_598034 != nil:
    section.add "quotaUser", valid_598034
  var valid_598035 = query.getOrDefault("alt")
  valid_598035 = validateParameter(valid_598035, JString, required = false,
                                 default = newJString("json"))
  if valid_598035 != nil:
    section.add "alt", valid_598035
  var valid_598036 = query.getOrDefault("startDate")
  valid_598036 = validateParameter(valid_598036, JString, required = false,
                                 default = nil)
  if valid_598036 != nil:
    section.add "startDate", valid_598036
  var valid_598037 = query.getOrDefault("oauth_token")
  valid_598037 = validateParameter(valid_598037, JString, required = false,
                                 default = nil)
  if valid_598037 != nil:
    section.add "oauth_token", valid_598037
  var valid_598038 = query.getOrDefault("userIp")
  valid_598038 = validateParameter(valid_598038, JString, required = false,
                                 default = nil)
  if valid_598038 != nil:
    section.add "userIp", valid_598038
  var valid_598039 = query.getOrDefault("maxResults")
  valid_598039 = validateParameter(valid_598039, JInt, required = false, default = nil)
  if valid_598039 != nil:
    section.add "maxResults", valid_598039
  var valid_598040 = query.getOrDefault("key")
  valid_598040 = validateParameter(valid_598040, JString, required = false,
                                 default = nil)
  if valid_598040 != nil:
    section.add "key", valid_598040
  var valid_598041 = query.getOrDefault("fetchBodies")
  valid_598041 = validateParameter(valid_598041, JBool, required = false, default = nil)
  if valid_598041 != nil:
    section.add "fetchBodies", valid_598041
  var valid_598042 = query.getOrDefault("prettyPrint")
  valid_598042 = validateParameter(valid_598042, JBool, required = false,
                                 default = newJBool(true))
  if valid_598042 != nil:
    section.add "prettyPrint", valid_598042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598043: Call_BloggerCommentsList_598027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, possibly filtered.
  ## 
  let valid = call_598043.validator(path, query, header, formData, body)
  let scheme = call_598043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598043.url(scheme.get, call_598043.host, call_598043.base,
                         call_598043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598043, url, valid)

proc call*(call_598044: Call_BloggerCommentsList_598027; postId: string;
          blogId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; startDate: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; fetchBodies: bool = false; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsList
  ## Retrieves the comments for a blog, possibly filtered.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token if request is paged.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   startDate: string
  ##            : Earliest date of comment to fetch, a date-time with RFC 3339 formatting.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of comments to include in the result.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   fetchBodies: bool
  ##              : Whether the body content of the comments is included.
  ##   blogId: string (required)
  ##         : ID of the blog to fetch comments from.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598045 = newJObject()
  var query_598046 = newJObject()
  add(query_598046, "fields", newJString(fields))
  add(query_598046, "pageToken", newJString(pageToken))
  add(query_598046, "quotaUser", newJString(quotaUser))
  add(query_598046, "alt", newJString(alt))
  add(query_598046, "startDate", newJString(startDate))
  add(query_598046, "oauth_token", newJString(oauthToken))
  add(query_598046, "userIp", newJString(userIp))
  add(query_598046, "maxResults", newJInt(maxResults))
  add(query_598046, "key", newJString(key))
  add(path_598045, "postId", newJString(postId))
  add(query_598046, "fetchBodies", newJBool(fetchBodies))
  add(path_598045, "blogId", newJString(blogId))
  add(query_598046, "prettyPrint", newJBool(prettyPrint))
  result = call_598044.call(path_598045, query_598046, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_598027(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_598028, base: "/blogger/v2",
    url: url_BloggerCommentsList_598029, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_598047 = ref object of OpenApiRestCall_597408
proc url_BloggerCommentsGet_598049(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  assert "postId" in path, "`postId` is a required path parameter"
  assert "commentId" in path, "`commentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId"),
               (kind: ConstantSegment, value: "/posts/"),
               (kind: VariableSegment, value: "postId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "commentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerCommentsGet_598048(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets one comment by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   commentId: JString (required)
  ##            : The ID of the comment to get.
  ##   postId: JString (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: JString (required)
  ##         : ID of the blog to containing the comment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `commentId` field"
  var valid_598050 = path.getOrDefault("commentId")
  valid_598050 = validateParameter(valid_598050, JString, required = true,
                                 default = nil)
  if valid_598050 != nil:
    section.add "commentId", valid_598050
  var valid_598051 = path.getOrDefault("postId")
  valid_598051 = validateParameter(valid_598051, JString, required = true,
                                 default = nil)
  if valid_598051 != nil:
    section.add "postId", valid_598051
  var valid_598052 = path.getOrDefault("blogId")
  valid_598052 = validateParameter(valid_598052, JString, required = true,
                                 default = nil)
  if valid_598052 != nil:
    section.add "blogId", valid_598052
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
  var valid_598053 = query.getOrDefault("fields")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "fields", valid_598053
  var valid_598054 = query.getOrDefault("quotaUser")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "quotaUser", valid_598054
  var valid_598055 = query.getOrDefault("alt")
  valid_598055 = validateParameter(valid_598055, JString, required = false,
                                 default = newJString("json"))
  if valid_598055 != nil:
    section.add "alt", valid_598055
  var valid_598056 = query.getOrDefault("oauth_token")
  valid_598056 = validateParameter(valid_598056, JString, required = false,
                                 default = nil)
  if valid_598056 != nil:
    section.add "oauth_token", valid_598056
  var valid_598057 = query.getOrDefault("userIp")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "userIp", valid_598057
  var valid_598058 = query.getOrDefault("key")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "key", valid_598058
  var valid_598059 = query.getOrDefault("prettyPrint")
  valid_598059 = validateParameter(valid_598059, JBool, required = false,
                                 default = newJBool(true))
  if valid_598059 != nil:
    section.add "prettyPrint", valid_598059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598060: Call_BloggerCommentsGet_598047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by id.
  ## 
  let valid = call_598060.validator(path, query, header, formData, body)
  let scheme = call_598060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598060.url(scheme.get, call_598060.host, call_598060.base,
                         call_598060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598060, url, valid)

proc call*(call_598061: Call_BloggerCommentsGet_598047; commentId: string;
          postId: string; blogId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## bloggerCommentsGet
  ## Gets one comment by id.
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
  ##   commentId: string (required)
  ##            : The ID of the comment to get.
  ##   postId: string (required)
  ##         : ID of the post to fetch posts from.
  ##   blogId: string (required)
  ##         : ID of the blog to containing the comment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598062 = newJObject()
  var query_598063 = newJObject()
  add(query_598063, "fields", newJString(fields))
  add(query_598063, "quotaUser", newJString(quotaUser))
  add(query_598063, "alt", newJString(alt))
  add(query_598063, "oauth_token", newJString(oauthToken))
  add(query_598063, "userIp", newJString(userIp))
  add(query_598063, "key", newJString(key))
  add(path_598062, "commentId", newJString(commentId))
  add(path_598062, "postId", newJString(postId))
  add(path_598062, "blogId", newJString(blogId))
  add(query_598063, "prettyPrint", newJBool(prettyPrint))
  result = call_598061.call(path_598062, query_598063, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_598047(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_598048, base: "/blogger/v2",
    url: url_BloggerCommentsGet_598049, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_598064 = ref object of OpenApiRestCall_597408
proc url_BloggerUsersGet_598066(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersGet_598065(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets one user by id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_598067 = path.getOrDefault("userId")
  valid_598067 = validateParameter(valid_598067, JString, required = true,
                                 default = nil)
  if valid_598067 != nil:
    section.add "userId", valid_598067
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
  var valid_598068 = query.getOrDefault("fields")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "fields", valid_598068
  var valid_598069 = query.getOrDefault("quotaUser")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "quotaUser", valid_598069
  var valid_598070 = query.getOrDefault("alt")
  valid_598070 = validateParameter(valid_598070, JString, required = false,
                                 default = newJString("json"))
  if valid_598070 != nil:
    section.add "alt", valid_598070
  var valid_598071 = query.getOrDefault("oauth_token")
  valid_598071 = validateParameter(valid_598071, JString, required = false,
                                 default = nil)
  if valid_598071 != nil:
    section.add "oauth_token", valid_598071
  var valid_598072 = query.getOrDefault("userIp")
  valid_598072 = validateParameter(valid_598072, JString, required = false,
                                 default = nil)
  if valid_598072 != nil:
    section.add "userIp", valid_598072
  var valid_598073 = query.getOrDefault("key")
  valid_598073 = validateParameter(valid_598073, JString, required = false,
                                 default = nil)
  if valid_598073 != nil:
    section.add "key", valid_598073
  var valid_598074 = query.getOrDefault("prettyPrint")
  valid_598074 = validateParameter(valid_598074, JBool, required = false,
                                 default = newJBool(true))
  if valid_598074 != nil:
    section.add "prettyPrint", valid_598074
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598075: Call_BloggerUsersGet_598064; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by id.
  ## 
  let valid = call_598075.validator(path, query, header, formData, body)
  let scheme = call_598075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598075.url(scheme.get, call_598075.host, call_598075.base,
                         call_598075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598075, url, valid)

proc call*(call_598076: Call_BloggerUsersGet_598064; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerUsersGet
  ## Gets one user by id.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user to get.
  var path_598077 = newJObject()
  var query_598078 = newJObject()
  add(query_598078, "fields", newJString(fields))
  add(query_598078, "quotaUser", newJString(quotaUser))
  add(query_598078, "alt", newJString(alt))
  add(query_598078, "oauth_token", newJString(oauthToken))
  add(query_598078, "userIp", newJString(userIp))
  add(query_598078, "key", newJString(key))
  add(query_598078, "prettyPrint", newJBool(prettyPrint))
  add(path_598077, "userId", newJString(userId))
  result = call_598076.call(path_598077, query_598078, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_598064(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_598065, base: "/blogger/v2",
    url: url_BloggerUsersGet_598066, schemes: {Scheme.Https})
type
  Call_BloggerUsersBlogsList_598079 = ref object of OpenApiRestCall_597408
proc url_BloggerUsersBlogsList_598081(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/blogs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersBlogsList_598080(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_598082 = path.getOrDefault("userId")
  valid_598082 = validateParameter(valid_598082, JString, required = true,
                                 default = nil)
  if valid_598082 != nil:
    section.add "userId", valid_598082
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
  var valid_598083 = query.getOrDefault("fields")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = nil)
  if valid_598083 != nil:
    section.add "fields", valid_598083
  var valid_598084 = query.getOrDefault("quotaUser")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "quotaUser", valid_598084
  var valid_598085 = query.getOrDefault("alt")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = newJString("json"))
  if valid_598085 != nil:
    section.add "alt", valid_598085
  var valid_598086 = query.getOrDefault("oauth_token")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "oauth_token", valid_598086
  var valid_598087 = query.getOrDefault("userIp")
  valid_598087 = validateParameter(valid_598087, JString, required = false,
                                 default = nil)
  if valid_598087 != nil:
    section.add "userIp", valid_598087
  var valid_598088 = query.getOrDefault("key")
  valid_598088 = validateParameter(valid_598088, JString, required = false,
                                 default = nil)
  if valid_598088 != nil:
    section.add "key", valid_598088
  var valid_598089 = query.getOrDefault("prettyPrint")
  valid_598089 = validateParameter(valid_598089, JBool, required = false,
                                 default = newJBool(true))
  if valid_598089 != nil:
    section.add "prettyPrint", valid_598089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598090: Call_BloggerUsersBlogsList_598079; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_598090.validator(path, query, header, formData, body)
  let scheme = call_598090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598090.url(scheme.get, call_598090.host, call_598090.base,
                         call_598090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598090, url, valid)

proc call*(call_598091: Call_BloggerUsersBlogsList_598079; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## bloggerUsersBlogsList
  ## Retrieves a list of blogs, possibly filtered.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : ID of the user whose blogs are to be fetched. Either the word 'self' (sans quote marks) or the user's profile identifier.
  var path_598092 = newJObject()
  var query_598093 = newJObject()
  add(query_598093, "fields", newJString(fields))
  add(query_598093, "quotaUser", newJString(quotaUser))
  add(query_598093, "alt", newJString(alt))
  add(query_598093, "oauth_token", newJString(oauthToken))
  add(query_598093, "userIp", newJString(userIp))
  add(query_598093, "key", newJString(key))
  add(query_598093, "prettyPrint", newJBool(prettyPrint))
  add(path_598092, "userId", newJString(userId))
  result = call_598091.call(path_598092, query_598093, nil, nil, nil)

var bloggerUsersBlogsList* = Call_BloggerUsersBlogsList_598079(
    name: "bloggerUsersBlogsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerUsersBlogsList_598080, base: "/blogger/v2",
    url: url_BloggerUsersBlogsList_598081, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
