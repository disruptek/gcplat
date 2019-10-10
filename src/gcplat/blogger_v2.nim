
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  gcpServiceName = "blogger"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BloggerBlogsGet_588709 = ref object of OpenApiRestCall_588441
proc url_BloggerBlogsGet_588711(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "blogId" in path, "`blogId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/blogs/"),
               (kind: VariableSegment, value: "blogId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerBlogsGet_588710(path: JsonNode; query: JsonNode;
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
  var valid_588837 = path.getOrDefault("blogId")
  valid_588837 = validateParameter(valid_588837, JString, required = true,
                                 default = nil)
  if valid_588837 != nil:
    section.add "blogId", valid_588837
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
  var valid_588838 = query.getOrDefault("fields")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = nil)
  if valid_588838 != nil:
    section.add "fields", valid_588838
  var valid_588839 = query.getOrDefault("quotaUser")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "quotaUser", valid_588839
  var valid_588853 = query.getOrDefault("alt")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = newJString("json"))
  if valid_588853 != nil:
    section.add "alt", valid_588853
  var valid_588854 = query.getOrDefault("oauth_token")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "oauth_token", valid_588854
  var valid_588855 = query.getOrDefault("userIp")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "userIp", valid_588855
  var valid_588856 = query.getOrDefault("key")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "key", valid_588856
  var valid_588857 = query.getOrDefault("prettyPrint")
  valid_588857 = validateParameter(valid_588857, JBool, required = false,
                                 default = newJBool(true))
  if valid_588857 != nil:
    section.add "prettyPrint", valid_588857
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588880: Call_BloggerBlogsGet_588709; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog by id.
  ## 
  let valid = call_588880.validator(path, query, header, formData, body)
  let scheme = call_588880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588880.url(scheme.get, call_588880.host, call_588880.base,
                         call_588880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588880, url, valid)

proc call*(call_588951: Call_BloggerBlogsGet_588709; blogId: string;
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
  var path_588952 = newJObject()
  var query_588954 = newJObject()
  add(query_588954, "fields", newJString(fields))
  add(query_588954, "quotaUser", newJString(quotaUser))
  add(query_588954, "alt", newJString(alt))
  add(query_588954, "oauth_token", newJString(oauthToken))
  add(query_588954, "userIp", newJString(userIp))
  add(query_588954, "key", newJString(key))
  add(path_588952, "blogId", newJString(blogId))
  add(query_588954, "prettyPrint", newJBool(prettyPrint))
  result = call_588951.call(path_588952, query_588954, nil, nil, nil)

var bloggerBlogsGet* = Call_BloggerBlogsGet_588709(name: "bloggerBlogsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/blogs/{blogId}",
    validator: validate_BloggerBlogsGet_588710, base: "/blogger/v2",
    url: url_BloggerBlogsGet_588711, schemes: {Scheme.Https})
type
  Call_BloggerPagesList_588993 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesList_588995(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerPagesList_588994(path: JsonNode; query: JsonNode;
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
  var valid_588996 = path.getOrDefault("blogId")
  valid_588996 = validateParameter(valid_588996, JString, required = true,
                                 default = nil)
  if valid_588996 != nil:
    section.add "blogId", valid_588996
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
  var valid_589003 = query.getOrDefault("fetchBodies")
  valid_589003 = validateParameter(valid_589003, JBool, required = false, default = nil)
  if valid_589003 != nil:
    section.add "fetchBodies", valid_589003
  var valid_589004 = query.getOrDefault("prettyPrint")
  valid_589004 = validateParameter(valid_589004, JBool, required = false,
                                 default = newJBool(true))
  if valid_589004 != nil:
    section.add "prettyPrint", valid_589004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589005: Call_BloggerPagesList_588993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves pages for a blog, possibly filtered.
  ## 
  let valid = call_589005.validator(path, query, header, formData, body)
  let scheme = call_589005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589005.url(scheme.get, call_589005.host, call_589005.base,
                         call_589005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589005, url, valid)

proc call*(call_589006: Call_BloggerPagesList_588993; blogId: string;
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
  var path_589007 = newJObject()
  var query_589008 = newJObject()
  add(query_589008, "fields", newJString(fields))
  add(query_589008, "quotaUser", newJString(quotaUser))
  add(query_589008, "alt", newJString(alt))
  add(query_589008, "oauth_token", newJString(oauthToken))
  add(query_589008, "userIp", newJString(userIp))
  add(query_589008, "key", newJString(key))
  add(query_589008, "fetchBodies", newJBool(fetchBodies))
  add(path_589007, "blogId", newJString(blogId))
  add(query_589008, "prettyPrint", newJBool(prettyPrint))
  result = call_589006.call(path_589007, query_589008, nil, nil, nil)

var bloggerPagesList* = Call_BloggerPagesList_588993(name: "bloggerPagesList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages", validator: validate_BloggerPagesList_588994,
    base: "/blogger/v2", url: url_BloggerPagesList_588995, schemes: {Scheme.Https})
type
  Call_BloggerPagesGet_589009 = ref object of OpenApiRestCall_588441
proc url_BloggerPagesGet_589011(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerPagesGet_589010(path: JsonNode; query: JsonNode;
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
  var valid_589012 = path.getOrDefault("pageId")
  valid_589012 = validateParameter(valid_589012, JString, required = true,
                                 default = nil)
  if valid_589012 != nil:
    section.add "pageId", valid_589012
  var valid_589013 = path.getOrDefault("blogId")
  valid_589013 = validateParameter(valid_589013, JString, required = true,
                                 default = nil)
  if valid_589013 != nil:
    section.add "blogId", valid_589013
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
  var valid_589014 = query.getOrDefault("fields")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "fields", valid_589014
  var valid_589015 = query.getOrDefault("quotaUser")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "quotaUser", valid_589015
  var valid_589016 = query.getOrDefault("alt")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("json"))
  if valid_589016 != nil:
    section.add "alt", valid_589016
  var valid_589017 = query.getOrDefault("oauth_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "oauth_token", valid_589017
  var valid_589018 = query.getOrDefault("userIp")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "userIp", valid_589018
  var valid_589019 = query.getOrDefault("key")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "key", valid_589019
  var valid_589020 = query.getOrDefault("prettyPrint")
  valid_589020 = validateParameter(valid_589020, JBool, required = false,
                                 default = newJBool(true))
  if valid_589020 != nil:
    section.add "prettyPrint", valid_589020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589021: Call_BloggerPagesGet_589009; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one blog page by id.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_BloggerPagesGet_589009; pageId: string; blogId: string;
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
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "userIp", newJString(userIp))
  add(query_589024, "key", newJString(key))
  add(path_589023, "pageId", newJString(pageId))
  add(path_589023, "blogId", newJString(blogId))
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(path_589023, query_589024, nil, nil, nil)

var bloggerPagesGet* = Call_BloggerPagesGet_589009(name: "bloggerPagesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/pages/{pageId}", validator: validate_BloggerPagesGet_589010,
    base: "/blogger/v2", url: url_BloggerPagesGet_589011, schemes: {Scheme.Https})
type
  Call_BloggerPostsList_589025 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsList_589027(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerPostsList_589026(path: JsonNode; query: JsonNode;
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
  var valid_589028 = path.getOrDefault("blogId")
  valid_589028 = validateParameter(valid_589028, JString, required = true,
                                 default = nil)
  if valid_589028 != nil:
    section.add "blogId", valid_589028
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
  var valid_589029 = query.getOrDefault("fields")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "fields", valid_589029
  var valid_589030 = query.getOrDefault("pageToken")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "pageToken", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("startDate")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "startDate", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("userIp")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "userIp", valid_589035
  var valid_589036 = query.getOrDefault("maxResults")
  valid_589036 = validateParameter(valid_589036, JInt, required = false, default = nil)
  if valid_589036 != nil:
    section.add "maxResults", valid_589036
  var valid_589037 = query.getOrDefault("key")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "key", valid_589037
  var valid_589038 = query.getOrDefault("fetchBodies")
  valid_589038 = validateParameter(valid_589038, JBool, required = false, default = nil)
  if valid_589038 != nil:
    section.add "fetchBodies", valid_589038
  var valid_589039 = query.getOrDefault("prettyPrint")
  valid_589039 = validateParameter(valid_589039, JBool, required = false,
                                 default = newJBool(true))
  if valid_589039 != nil:
    section.add "prettyPrint", valid_589039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589040: Call_BloggerPostsList_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of posts, possibly filtered.
  ## 
  let valid = call_589040.validator(path, query, header, formData, body)
  let scheme = call_589040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589040.url(scheme.get, call_589040.host, call_589040.base,
                         call_589040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589040, url, valid)

proc call*(call_589041: Call_BloggerPostsList_589025; blogId: string;
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
  var path_589042 = newJObject()
  var query_589043 = newJObject()
  add(query_589043, "fields", newJString(fields))
  add(query_589043, "pageToken", newJString(pageToken))
  add(query_589043, "quotaUser", newJString(quotaUser))
  add(query_589043, "alt", newJString(alt))
  add(query_589043, "startDate", newJString(startDate))
  add(query_589043, "oauth_token", newJString(oauthToken))
  add(query_589043, "userIp", newJString(userIp))
  add(query_589043, "maxResults", newJInt(maxResults))
  add(query_589043, "key", newJString(key))
  add(query_589043, "fetchBodies", newJBool(fetchBodies))
  add(path_589042, "blogId", newJString(blogId))
  add(query_589043, "prettyPrint", newJBool(prettyPrint))
  result = call_589041.call(path_589042, query_589043, nil, nil, nil)

var bloggerPostsList* = Call_BloggerPostsList_589025(name: "bloggerPostsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts", validator: validate_BloggerPostsList_589026,
    base: "/blogger/v2", url: url_BloggerPostsList_589027, schemes: {Scheme.Https})
type
  Call_BloggerPostsGet_589044 = ref object of OpenApiRestCall_588441
proc url_BloggerPostsGet_589046(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerPostsGet_589045(path: JsonNode; query: JsonNode;
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
  var valid_589047 = path.getOrDefault("postId")
  valid_589047 = validateParameter(valid_589047, JString, required = true,
                                 default = nil)
  if valid_589047 != nil:
    section.add "postId", valid_589047
  var valid_589048 = path.getOrDefault("blogId")
  valid_589048 = validateParameter(valid_589048, JString, required = true,
                                 default = nil)
  if valid_589048 != nil:
    section.add "blogId", valid_589048
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
  var valid_589049 = query.getOrDefault("fields")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "fields", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("alt")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("json"))
  if valid_589051 != nil:
    section.add "alt", valid_589051
  var valid_589052 = query.getOrDefault("oauth_token")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "oauth_token", valid_589052
  var valid_589053 = query.getOrDefault("userIp")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "userIp", valid_589053
  var valid_589054 = query.getOrDefault("key")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "key", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589056: Call_BloggerPostsGet_589044; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a post by id.
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_BloggerPostsGet_589044; postId: string; blogId: string;
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
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "userIp", newJString(userIp))
  add(query_589059, "key", newJString(key))
  add(path_589058, "postId", newJString(postId))
  add(path_589058, "blogId", newJString(blogId))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589057.call(path_589058, query_589059, nil, nil, nil)

var bloggerPostsGet* = Call_BloggerPostsGet_589044(name: "bloggerPostsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}", validator: validate_BloggerPostsGet_589045,
    base: "/blogger/v2", url: url_BloggerPostsGet_589046, schemes: {Scheme.Https})
type
  Call_BloggerCommentsList_589060 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsList_589062(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerCommentsList_589061(path: JsonNode; query: JsonNode;
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
  var valid_589063 = path.getOrDefault("postId")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "postId", valid_589063
  var valid_589064 = path.getOrDefault("blogId")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "blogId", valid_589064
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
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("pageToken")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "pageToken", valid_589066
  var valid_589067 = query.getOrDefault("quotaUser")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "quotaUser", valid_589067
  var valid_589068 = query.getOrDefault("alt")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("json"))
  if valid_589068 != nil:
    section.add "alt", valid_589068
  var valid_589069 = query.getOrDefault("startDate")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "startDate", valid_589069
  var valid_589070 = query.getOrDefault("oauth_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "oauth_token", valid_589070
  var valid_589071 = query.getOrDefault("userIp")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "userIp", valid_589071
  var valid_589072 = query.getOrDefault("maxResults")
  valid_589072 = validateParameter(valid_589072, JInt, required = false, default = nil)
  if valid_589072 != nil:
    section.add "maxResults", valid_589072
  var valid_589073 = query.getOrDefault("key")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "key", valid_589073
  var valid_589074 = query.getOrDefault("fetchBodies")
  valid_589074 = validateParameter(valid_589074, JBool, required = false, default = nil)
  if valid_589074 != nil:
    section.add "fetchBodies", valid_589074
  var valid_589075 = query.getOrDefault("prettyPrint")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "prettyPrint", valid_589075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589076: Call_BloggerCommentsList_589060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the comments for a blog, possibly filtered.
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_BloggerCommentsList_589060; postId: string;
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
  var path_589078 = newJObject()
  var query_589079 = newJObject()
  add(query_589079, "fields", newJString(fields))
  add(query_589079, "pageToken", newJString(pageToken))
  add(query_589079, "quotaUser", newJString(quotaUser))
  add(query_589079, "alt", newJString(alt))
  add(query_589079, "startDate", newJString(startDate))
  add(query_589079, "oauth_token", newJString(oauthToken))
  add(query_589079, "userIp", newJString(userIp))
  add(query_589079, "maxResults", newJInt(maxResults))
  add(query_589079, "key", newJString(key))
  add(path_589078, "postId", newJString(postId))
  add(query_589079, "fetchBodies", newJBool(fetchBodies))
  add(path_589078, "blogId", newJString(blogId))
  add(query_589079, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(path_589078, query_589079, nil, nil, nil)

var bloggerCommentsList* = Call_BloggerCommentsList_589060(
    name: "bloggerCommentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/blogs/{blogId}/posts/{postId}/comments",
    validator: validate_BloggerCommentsList_589061, base: "/blogger/v2",
    url: url_BloggerCommentsList_589062, schemes: {Scheme.Https})
type
  Call_BloggerCommentsGet_589080 = ref object of OpenApiRestCall_588441
proc url_BloggerCommentsGet_589082(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerCommentsGet_589081(path: JsonNode; query: JsonNode;
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
  var valid_589083 = path.getOrDefault("commentId")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "commentId", valid_589083
  var valid_589084 = path.getOrDefault("postId")
  valid_589084 = validateParameter(valid_589084, JString, required = true,
                                 default = nil)
  if valid_589084 != nil:
    section.add "postId", valid_589084
  var valid_589085 = path.getOrDefault("blogId")
  valid_589085 = validateParameter(valid_589085, JString, required = true,
                                 default = nil)
  if valid_589085 != nil:
    section.add "blogId", valid_589085
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
  var valid_589086 = query.getOrDefault("fields")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "fields", valid_589086
  var valid_589087 = query.getOrDefault("quotaUser")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "quotaUser", valid_589087
  var valid_589088 = query.getOrDefault("alt")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("json"))
  if valid_589088 != nil:
    section.add "alt", valid_589088
  var valid_589089 = query.getOrDefault("oauth_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "oauth_token", valid_589089
  var valid_589090 = query.getOrDefault("userIp")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "userIp", valid_589090
  var valid_589091 = query.getOrDefault("key")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "key", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589093: Call_BloggerCommentsGet_589080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one comment by id.
  ## 
  let valid = call_589093.validator(path, query, header, formData, body)
  let scheme = call_589093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589093.url(scheme.get, call_589093.host, call_589093.base,
                         call_589093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589093, url, valid)

proc call*(call_589094: Call_BloggerCommentsGet_589080; commentId: string;
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
  var path_589095 = newJObject()
  var query_589096 = newJObject()
  add(query_589096, "fields", newJString(fields))
  add(query_589096, "quotaUser", newJString(quotaUser))
  add(query_589096, "alt", newJString(alt))
  add(query_589096, "oauth_token", newJString(oauthToken))
  add(query_589096, "userIp", newJString(userIp))
  add(query_589096, "key", newJString(key))
  add(path_589095, "commentId", newJString(commentId))
  add(path_589095, "postId", newJString(postId))
  add(path_589095, "blogId", newJString(blogId))
  add(query_589096, "prettyPrint", newJBool(prettyPrint))
  result = call_589094.call(path_589095, query_589096, nil, nil, nil)

var bloggerCommentsGet* = Call_BloggerCommentsGet_589080(
    name: "bloggerCommentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/blogs/{blogId}/posts/{postId}/comments/{commentId}",
    validator: validate_BloggerCommentsGet_589081, base: "/blogger/v2",
    url: url_BloggerCommentsGet_589082, schemes: {Scheme.Https})
type
  Call_BloggerUsersGet_589097 = ref object of OpenApiRestCall_588441
proc url_BloggerUsersGet_589099(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BloggerUsersGet_589098(path: JsonNode; query: JsonNode;
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
  var valid_589100 = path.getOrDefault("userId")
  valid_589100 = validateParameter(valid_589100, JString, required = true,
                                 default = nil)
  if valid_589100 != nil:
    section.add "userId", valid_589100
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
  var valid_589101 = query.getOrDefault("fields")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "fields", valid_589101
  var valid_589102 = query.getOrDefault("quotaUser")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "quotaUser", valid_589102
  var valid_589103 = query.getOrDefault("alt")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("json"))
  if valid_589103 != nil:
    section.add "alt", valid_589103
  var valid_589104 = query.getOrDefault("oauth_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "oauth_token", valid_589104
  var valid_589105 = query.getOrDefault("userIp")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "userIp", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589108: Call_BloggerUsersGet_589097; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets one user by id.
  ## 
  let valid = call_589108.validator(path, query, header, formData, body)
  let scheme = call_589108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589108.url(scheme.get, call_589108.host, call_589108.base,
                         call_589108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589108, url, valid)

proc call*(call_589109: Call_BloggerUsersGet_589097; userId: string;
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
  var path_589110 = newJObject()
  var query_589111 = newJObject()
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "userIp", newJString(userIp))
  add(query_589111, "key", newJString(key))
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  add(path_589110, "userId", newJString(userId))
  result = call_589109.call(path_589110, query_589111, nil, nil, nil)

var bloggerUsersGet* = Call_BloggerUsersGet_589097(name: "bloggerUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userId}",
    validator: validate_BloggerUsersGet_589098, base: "/blogger/v2",
    url: url_BloggerUsersGet_589099, schemes: {Scheme.Https})
type
  Call_BloggerUsersBlogsList_589112 = ref object of OpenApiRestCall_588441
proc url_BloggerUsersBlogsList_589114(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_BloggerUsersBlogsList_589113(path: JsonNode; query: JsonNode;
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
  var valid_589115 = path.getOrDefault("userId")
  valid_589115 = validateParameter(valid_589115, JString, required = true,
                                 default = nil)
  if valid_589115 != nil:
    section.add "userId", valid_589115
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
  var valid_589116 = query.getOrDefault("fields")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "fields", valid_589116
  var valid_589117 = query.getOrDefault("quotaUser")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "quotaUser", valid_589117
  var valid_589118 = query.getOrDefault("alt")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = newJString("json"))
  if valid_589118 != nil:
    section.add "alt", valid_589118
  var valid_589119 = query.getOrDefault("oauth_token")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "oauth_token", valid_589119
  var valid_589120 = query.getOrDefault("userIp")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "userIp", valid_589120
  var valid_589121 = query.getOrDefault("key")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "key", valid_589121
  var valid_589122 = query.getOrDefault("prettyPrint")
  valid_589122 = validateParameter(valid_589122, JBool, required = false,
                                 default = newJBool(true))
  if valid_589122 != nil:
    section.add "prettyPrint", valid_589122
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589123: Call_BloggerUsersBlogsList_589112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of blogs, possibly filtered.
  ## 
  let valid = call_589123.validator(path, query, header, formData, body)
  let scheme = call_589123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589123.url(scheme.get, call_589123.host, call_589123.base,
                         call_589123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589123, url, valid)

proc call*(call_589124: Call_BloggerUsersBlogsList_589112; userId: string;
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
  var path_589125 = newJObject()
  var query_589126 = newJObject()
  add(query_589126, "fields", newJString(fields))
  add(query_589126, "quotaUser", newJString(quotaUser))
  add(query_589126, "alt", newJString(alt))
  add(query_589126, "oauth_token", newJString(oauthToken))
  add(query_589126, "userIp", newJString(userIp))
  add(query_589126, "key", newJString(key))
  add(query_589126, "prettyPrint", newJBool(prettyPrint))
  add(path_589125, "userId", newJString(userId))
  result = call_589124.call(path_589125, query_589126, nil, nil, nil)

var bloggerUsersBlogsList* = Call_BloggerUsersBlogsList_589112(
    name: "bloggerUsersBlogsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userId}/blogs",
    validator: validate_BloggerUsersBlogsList_589113, base: "/blogger/v2",
    url: url_BloggerUsersBlogsList_589114, schemes: {Scheme.Https})
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
